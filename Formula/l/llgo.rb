class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/xgo-dev/llgo"
  url "https://github.com/xgo-dev/llgo/archive/refs/tags/v1.0.10.tar.gz"
  sha256 "6a7a981062bafe849ecab765a7dd03c6893edc2d589541d33753a98dd402e4da"
  license "Apache-2.0"
  head "https://github.com/xgo-dev/llgo.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    manifest_sha256 "5bd082eb89c38d58e3677246e9c61e46f9f3927ce0bc8b530a0e4457e6854916"
    sha256 cellar: :any, arm64_golden_gate: "9fb2dfeeb8c94e73ecffbd60b4e017d3d3a6b8efc1e0185d1ed1114a4c345823"
    sha256 cellar: :any, arm64_tahoe:       "63cd9cda2c301532c050f3ccaefd37b9d4208782bfaca320366de1e39578250b"
    sha256 cellar: :any, arm64_sequoia:     "29d94237fb351b3591120ab02959216d44fbff9057af02368b6223ba9268b419"
    sha256               arm64_linux:       "5b658bbfef3918513d103b61feb0c102f8e72f89c779ee64aea888aa55a0a2bb"
    sha256               x86_64_linux:      "ca5d64844ee4f8baf12632165b7aee468571ac91d8669d034dbeca608348850f"
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

  def install
    llvm = dep("llvm")
    module_path = "github.com/xgo-dev/llgo"
    ldflags = %W[
      -X #{module_path}/internal/env.buildVersion=v#{version}
      -X #{module_path}/internal/env.buildTime=#{time.iso8601}
      -X #{module_path}/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin}/llvm-config
    ]
    tags = []
    dependency_bins = %w[lld llvm go pkgconf].map { |name| dep(name).opt_bin }.join(":")
    script_env = { PATH: "#{dependency_bins}:${PATH}" }

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
      libunwind = dep("libunwind")
      script_env[:CFLAGS] = "-I#{libunwind.opt_include} ${CFLAGS}"
      script_env[:LDFLAGS] = "-L#{libunwind.opt_lib} -Wl,-rpath,#{libunwind.opt_lib} ${LDFLAGS}"
    end

    system "go", "build", *std_go_args(ldflags:, tags:), "./cmd/llgo"
    bin.env_script_all_files(libexec/"bin", script_env)
    libexec.install "LICENSE", "README.md", "go.mod", "go.sum", "runtime"
  end

  test do
    # Let LLGo select an installed SDK supported by LLVM 22.
    ENV.delete "SDKROOT" if OS.mac?

    go = dep("go")
    goos = shell_output("#{go.opt_bin}/go env GOOS").chomp
    goarch = shell_output("#{go.opt_bin}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    # Add bdw-gc library path to LD_LIBRARY_PATH, this is a workaround for the libgc.so not found issue
    # Will be fixed in the next release
    bdwgc = dep("bdw-gc")
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
    assert_match "PASS", shell_output("#{bin}/llgo test -v .")
  end
end
