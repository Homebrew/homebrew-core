class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.12.1.tar.gz"
  sha256 "a9ddf42295ab1348e231bdf42a6035f7a17d00ccfa820b4abf3680b222a3afbf"
  license "Apache-2.0"
  head "https://github.com/goplus/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "0af29c250002484947a0552af23412633ed6ac42d1e4e8347f0f42e6cb9669fd"
    sha256 cellar: :any, arm64_sequoia: "c77ad1d7acb4725c2256ad16be9228320e3177c1fb7e457441918dd49ff294a5"
    sha256 cellar: :any, arm64_sonoma:  "e34091160ad7c6a3731e08a98e6564bf00a89ce5fbaa6d52879469e9ed9e12b0"
    sha256 cellar: :any, sonoma:        "6d5a965d00e86404b9d84a05bc81ab8965373d1b429d3c7c65ada19818b86d8d"
    sha256               arm64_linux:   "9ad2d0bf453e0baa4b655d2005e918e70edb720f5202fb57e41bd03e8d4a5e33"
    sha256               x86_64_linux:  "e2c6cd5a0254e48ad57576576f12fc0a5d49c7b607fcf2b33f3cacdd742016ac"
  end

  # NOTE: Can be undeprecated if upstream adds support for Go 1.25+
  deprecate! date: "2026-02-11", because: "uses deprecated go@1.24"

  depends_on "bdw-gc"
  depends_on "go@1.24"
  depends_on "libuv"
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on "openssl@3"
  depends_on "pkgconf"

  uses_from_macos "libffi"

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
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
