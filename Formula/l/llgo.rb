class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.0-pre.3.tar.gz"
  sha256 "4f4a6469006925c46e0fd6547d8b44f49a9a2d2acc43304c153d136f410598fb"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "a69dfe92f0174bddd936c41ab15e24aba7d5da6b5ae7ece3f2f88445ccfe6294"
    sha256 cellar: :any, arm64_sequoia: "cfe6f68591ff9abb7ea2249da7f083c92ec88efd856f7200d9b6628c5a943428"
    sha256 cellar: :any, arm64_sonoma:  "7e4e99e73cd69c24a5908f213783858063980107a37c4cef4fff0710cec7c07e"
    sha256 cellar: :any, sonoma:        "14563b6d5da0dd0f5eeedbec90fb0eff4173ca48e6bbf427a8a73b43321750b0"
    sha256               arm64_linux:   "8f66517ae84493e5d2df91e066f1d4e9d781e9b9a290e2d12afdad82c326616f"
    sha256               x86_64_linux:  "4f1bc48d3326081d40afb359011bd7261e15425784300cbb703b586c37723d36"
  end

  depends_on "bdw-gc" => :no_linkage
  depends_on "go@1.25"
  depends_on "libuv" => :no_linkage
  depends_on "openssl@3"
  depends_on "pkgconf"

  uses_from_macos "libffi"

  on_macos do
    depends_on "lld@21"
    depends_on "llvm@21"
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lld@19"
    depends_on "llvm@19" # Newer LLVM doesn't work with aarch64-linux-unknown triple llgo passes
    depends_on "zlib-ng-compat"
  end

  def find_dep(name)
    deps.find { |f| f.name.match?(/^#{name}(@\d+(\.\d+)*)?$/) }
        .to_formula
  end

  def install
    llvm = find_dep("llvm")
    ldflags = %W[
      -X github.com/goplus/llgo/internal/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/internal/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin}/llvm-config
    ]
    tags = %W[llvm#{llvm.version.major}]
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
