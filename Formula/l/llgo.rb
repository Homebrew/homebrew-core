class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.9.tar.gz"
  sha256 "c911250a0adff0fa85dac188e31f67c80865b84936328b8794fb40f48dd3da43"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "783fa720eb415e27e21d877c785e3317052e0cfcb1e099736728810e2a1589da"
    sha256 cellar: :any, arm64_tahoe:       "f1fd3864548cf5ab9e0025e66dcd9ed4e4be2d40cd68861516d5d251bc1b2446"
    sha256 cellar: :any, arm64_sequoia:     "b6a81045850658996ecc5694f52f3461d0882f4cd1fffd4569ee707ccc84ec57"
    sha256               arm64_linux:       "15f9a388b965618551a608aad03f04c1ac752c71e9c713690f37d2e2e8608096"
    sha256               x86_64_linux:      "89c1655ee91278726cd1a4fbf879af6732ebb0116213fc7e790373eeb5c179ca"
  end

  depends_on "bdw-gc" => :no_linkage
  depends_on "go"
  depends_on "libuv" => :no_linkage
  depends_on "lld@22"
  depends_on "llvm@22"
  depends_on "openssl@4" => :no_linkage # runtime/internal/clite/openssl/openssl.go
  depends_on "pkgconf"

  uses_from_macos "libffi"

  on_linux do
    depends_on "libunwind"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def find_dep(name)
    deps.find { |f| f.name.match?(/^#{name}(@\d+(\.\d+)*)?$/) }.name
  end

  def install
    llvm = find_dep("llvm")
    module_path = "github.com/xgo-dev/llgo"
    ldflags = %W[
      -X #{module_path}/internal/env.buildVersion=v#{version}
      -X #{module_path}/internal/env.buildTime=#{time.iso8601}
      -X #{module_path}/xtool/env/llvm.ldLLVMConfigBin=#{formula_opt_bin(llvm)}/llvm-config
    ]
    tags = []
    path_deps = %w[lld llvm go pkgconf].map { |name| formula_opt_bin(find_dep(name)) }
    script_env = { PATH: "#{path_deps.join(":")}:${PATH}" }

    if OS.linux?
      # Workaround to avoid patchelf corruption when cgo is required
      if Hardware::CPU.arm64?
        ENV["CGO_ENABLED"] = "1"
        ENV["GO_EXTLINK_ENABLED"] = "1"
        ENV.append "GOFLAGS", "-buildmode=pie"
      end

      ENV.prepend "CGO_CPPFLAGS",
        "-I#{formula_opt_include(llvm)} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{formula_opt_lib(llvm)} -lLLVM"

      tags << "byollvm"
      libunwind = find_dep("libunwind")
      script_env[:CFLAGS] = "-I#{formula_opt_include(libunwind)} ${CFLAGS}"
      script_env[:LDFLAGS] = "-L#{formula_opt_lib(libunwind)} -Wl,-rpath,#{formula_opt_lib(libunwind)} ${LDFLAGS}"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/llgo"
    bin.env_script_all_files(libexec/"bin", script_env)
    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"
  end

  test do
    # Let LLGo select an installed SDK supported by LLVM 22.
    ENV.delete "SDKROOT" if OS.mac?

    go = find_dep("go")
    goos = shell_output("#{formula_opt_bin(go)}/go env GOOS").chomp
    goarch = shell_output("#{formula_opt_bin(go)}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = find_dep("bdw-gc")
    ENV.prepend_path "LD_LIBRARY_PATH", formula_opt_lib(bdwgc)

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
    system formula_opt_bin(go)/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal expected, shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal expected, shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test -v .")
  end
end
