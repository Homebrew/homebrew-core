class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.12.0.tar.gz"
  sha256 "f14b906df548a4c5d95e64fb9763c147c6bc6bbc95dad9e3717f4eecd79517e6"
  license "Apache-2.0"
  head "https://github.com/goplus/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "054e0c28992eb84c51da8f91573d03e3b0fdf63e2154a71806eb4e36e560cf99"
    sha256 cellar: :any, arm64_sequoia: "05375280111579545efa9534e3f8fd2e7e37fe0de567200748faab51a24399c8"
    sha256 cellar: :any, arm64_sonoma:  "a9a2db8e19c76b462d5ec55ffede5db19b82dd312d928486f721da770ccba44a"
    sha256 cellar: :any, sonoma:        "42b030beffb17ee227734c6164e2627988d6c142f21a4fdfa1a81d807ffadf38"
    sha256               arm64_linux:   "3d01a48a92529788dab1739f9857a5dafa240540650f8d76359f628dfac369eb"
    sha256               x86_64_linux:  "ccb3bdac23e5d88f62d10db7a1e32779bd74a74049929dc603201c0743c4c397"
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
