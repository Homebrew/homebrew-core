class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.11.6.tar.gz"
  sha256 "94e3187d0b8d4be48afc0d609b01df1ba7bf36b6ab713318ad29363a1043297b"
  license "Apache-2.0"
  head "https://github.com/goplus/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "fb74c5fb2ba0ce01583d483029d077952dd55346dff06fdc2beb0949cf2c695b"
    sha256 cellar: :any, arm64_sequoia: "0c4b4f45dcf683285fbd6db973db96d64446a247b5b215bfb52e22a8a4204f86"
    sha256 cellar: :any, arm64_sonoma:  "6f45883b556962736d7e276f33d4fcc47cff59b370e0544532ef557afe1c1dac"
    sha256 cellar: :any, sonoma:        "13178f544ddf3d73fd57f0e16dec53f979245fad3d6556cc92c5a199b4ff5f54"
    sha256               arm64_linux:   "577b9fc95fb5845f93bb7321b26a3843532f84aceefa6dcf3a580b84c81ede91"
    sha256               x86_64_linux:  "62747f37803a846885e3d706cfef3f39a5a3940f238dffac02cd10ed120fc7f8"
  end

  depends_on "bdw-gc"
  depends_on "go@1.24"
  depends_on "libuv"
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on "openssl@3"
  depends_on "pkgconf"

  uses_from_macos "libffi"
  uses_from_macos "zlib"

  on_linux do
    depends_on "libunwind"
  end

  def find_dep(name)
    deps.find { |f| f.name.match?(/^#{name}(@\d+(\.\d+)*)?$/) }
        .to_formula
  end

  def install
    llvm = find_dep("llvm")
    ldflags = %W[
      -s -w
      -X github.com/goplus/llgo/internal/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/internal/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin/"llvm-config"}
    ]
    tags = nil
    if OS.linux?
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arch == :arm64
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end

      ENV.prepend "CGO_CPPFLAGS",
        "-I#{llvm.opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{llvm.opt_lib} -lLLVM"
      tags = "byollvm"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "-o", libexec/"bin/", "./cmd/llgo"

    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"

    path_deps = %w[lld go pkgconf].map { |name| find_dep(name).opt_bin }
    path_deps << llvm.opt_bin
    script_env = { PATH: "#{path_deps.join(":")}:$PATH" }

    if OS.linux?
      libunwind = find_dep("libunwind")
      script_env[:CFLAGS] = "-I#{libunwind.opt_include} $CFLAGS"
      script_env[:LDFLAGS] = "-L#{libunwind.opt_lib} -Wl,-rpath,#{libunwind.opt_lib} $LDFLAGS"
    end

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd, script_env
    end
  end

  test do
    go = find_dep("go")
    goos = shell_output("#{go.opt_bin}/go env GOOS").chomp
    goarch = shell_output("#{go.opt_bin}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = find_dep("bdw-gc")
    ENV.prepend_path "LD_LIBRARY_PATH", bdwgc.opt_lib

    (testpath/"hello.go").write <<~GO
      package main

      import (
          "fmt"

          "github.com/goplus/lib/c"
      )

      func Foo() string {
        return "Hello LLGo by Foo"
      }

      func main() {
        fmt.Println("Hello LLGo by fmt.Println")
        c.Printf(c.Str("Hello LLGo by c.Printf\\n"))
      }
    GO
    (testpath/"hello_test.go").write <<~GO
      package main

      import "testing"

      func Test_Foo(t *testing.T) {
        got := Foo()
        want := "Hello LLGo by Foo"
        if got != want {
          t.Errorf("foo() = %q, want %q", got, want)
        }
      }
    GO
    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system go.opt_bin/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal "Hello LLGo by fmt.Println\n" \
                 "Hello LLGo by c.Printf\n",
                 shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGo by fmt.Println\n" \
                 "Hello LLGo by c.Printf\n",
                 shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end
