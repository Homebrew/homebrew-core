class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.7.tar.gz"
  sha256 "c36331e74c8cd61ffd7315a1fcbf1210d5a4a073e609be8590a09f8d835602c9"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "e89d474ea3adc4c081ad66bec95ecb026c05115ab80047eb8533059cb6f89d82"
    sha256 cellar: :any, arm64_tahoe:       "2edd730f3bfd24e8ef862ee52d508abce10332ccb604102f95332477dc13fb34"
    sha256 cellar: :any, arm64_sequoia:     "c216c6e8c04074d96ed4d17f05d0718b622737a82a77d9d27229e770a375cb0e"
    sha256               arm64_linux:       "205d7c710a7285a468ad4f80cbda8c88dca4befd959ac02572be1579e1cb096b"
    sha256               x86_64_linux:      "635d20ce528fe9c79134232f94099e59ed3487ee0eda58c8ffc3347818c4bc3b"
  end

  depends_on "bdw-gc" => :no_linkage
  depends_on "go"
  depends_on "libuv" => :no_linkage
  depends_on "llvm@22"
  depends_on "openssl@4" => :no_linkage # runtime/internal/clite/openssl/openssl.go
  depends_on "pkgconf"

  uses_from_macos "libffi"

  on_macos do
    depends_on "lld" # LLD 23 is required for native links with macOS 27 SDK stubs
  end

  on_linux do
    depends_on "libunwind"
    depends_on "lld@22"
    depends_on "zlib-ng-compat"
  end

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
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

    if OS.mac? && Hardware::CPU.arm64?
      # Exercise macOS 27 SDK stub parsing even when testing with an older SDK.
      (testpath/"libllgo-sdk.tbd").write <<~TBD
        --- !tapi-tbd
        tbd-version: 4
        targets: [ arm64-macos, arm64e.x1-macos ]
        install-name: '@rpath/libllgo-sdk.dylib'
        current-version: 1.0.0
        ...
      TBD
      ENV.append "LDFLAGS", "-Wl,#{testpath}/libllgo-sdk.tbd,-dead_strip_dylibs"
    end

    expected = "Hello LLGo by fmt.Println\nHello LLGo by c.Printf\n"
    system go.opt_bin/"go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal expected, shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal expected, shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test -v .")
  end
end
