class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.4.tar.gz"
  sha256 "9479a9baa51d40c062ea77dd256f007b98e1b773c26ef224af5f7a393af845bd"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "ee6bd570bff321dc8aa0b38deb66eee67a30df17ed42da60a6a7261bbf5379a4"
    sha256 cellar: :any, arm64_tahoe:       "fbeef5372c8b6731f8d46544ce18d7c32c742c4c152e6b79087017b31c359b33"
    sha256 cellar: :any, arm64_sequoia:     "e0e4ca2ba35cc16fabf7466ca4d7ee80e797f96b8dd82cececab673583283fc1"
    sha256               arm64_linux:       "c3c65736a38e953cbbd52052c1bb437fcda39e100176791efd46b600a203adad"
    sha256               x86_64_linux:      "9cd548129b85d6dcd083dec580f7c4149e22f1fd30dbd2f723cfd22aa7faada6"
  end

  depends_on "bdw-gc" => :no_linkage
  depends_on "go"
  depends_on "libuv" => :no_linkage
  depends_on "lld@22"
  depends_on "llvm@22"
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
    module_path = "github.com/xgo-dev/llgo"
    ldflags = %W[
      -X #{module_path}/internal/env.buildVersion=v#{version}
      -X #{module_path}/internal/env.buildTime=#{time.iso8601}
      -X #{module_path}/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin}/llvm-config
    ]
    tags = []
    path_deps = %w[lld go pkgconf].map { |name| find_dep(name).opt_bin }
    path_deps << llvm.opt_bin
    script_env = { PATH: "#{path_deps.join(":")}:${PATH}" }

    if OS.linux?
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
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

      tags << "byollvm"
      libunwind = find_dep("libunwind")
      script_env[:CFLAGS] = "-I#{libunwind.opt_include} ${CFLAGS}"
      script_env[:LDFLAGS] = "-L#{libunwind.opt_lib} -Wl,-rpath,#{libunwind.opt_lib} ${LDFLAGS}"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/llgo"
    bin.env_script_all_files(libexec/"bin", script_env)
    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"
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

    (testpath/"hello.go").write <<~'GO'
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
        c.Printf(c.Str("Hello LLGo by c.Printf\n"))
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

    expected = "Hello LLGo by fmt.Println\nHello LLGo by c.Printf\n"
    system go.opt_bin/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal expected, shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal expected, shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end
