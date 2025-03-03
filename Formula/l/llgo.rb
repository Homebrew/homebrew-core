class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/cpunion/llgo/archive/refs/tags/v0.10.1.tar.gz"
  sha256 "2113aca02f119ee4d1651bcde0ab6dbe6611617cceaa8302cdd96dbf747cfd81"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "0eef02db81b85e529e3ab1312f9817892cb07d47f49db77bcd322490bccb7432"
    sha256 cellar: :any, arm64_sonoma:  "588654804dcef5836318a2fa1e7ddcf5baa1c2409f59fa630031e390dcc8c3af"
    sha256 cellar: :any, arm64_ventura: "d39e10b6eaede8376dca9d4ece753d9d59ef05a9b2df5747ea62f88214b6b3e9"
    sha256 cellar: :any, sonoma:        "e40074e4a6d5c9ccf0d296a3ee6e2f12ee86546d17e3127e51eae0d32712be0e"
    sha256 cellar: :any, ventura:       "04c84b6d696f5b9c68897d9fd39426e07e06a52eefd911c95645298a3634c734"
    sha256               x86_64_linux:  "10a922642cecc66b75420e9d661e4c12409c2ed7d379123c0d52d339b86de938"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "libffi"
  depends_on "libuv"
  depends_on "llvm@18"
  depends_on "openssl@3"
  depends_on "pkgconf"
  depends_on "zlib"

  def find_dep(name)
    deps.map(&:to_formula).find { |f| f.name.match?(/^#{name}(@\d+)?$/) }
  end

  def llvm
    find_dep("llvm")
  end

  def go
    find_dep("go")
  end

  def lib_deps
    %w[bdw-gc openssl libffi llvm zlib].map { |name| find_dep(name).opt_lib }
  end

  def path_deps
    deps = %w[llvm go pkgconf]
    deps.map { |name| find_dep(name).opt_bin }
  end

  def install
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{llvm.opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{llvm.opt_lib} -lLLVM"
    end

    ldflags = %W[
      -s -w
      -X github.com/goplus/llgo/compiler/internal/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/compiler/internal/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/compiler/internal/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin/"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    cd "compiler" do
      system go.opt_bin/"go", "build", *build_args, "-o", libexec/"bin/", "./cmd/llgo"
    end

    libexec.install "LICENSE", "README.md", "runtime"

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd,
        PATH:              "#{path_deps.join(":")}:$PATH",
        LD_LIBRARY_PATH:   "#{lib_deps.join(":")}:$LD_LIBRARY_PATH",
        DYLD_LIBRARY_PATH: "#{lib_deps.join(":")}:$DYLD_LIBRARY_PATH"
    end
  end

  test do
    ENV.prepend_path "LD_LIBRARY_PATH", lib_deps.join(":")

    goos = shell_output("#{go.opt_bin}/go env GOOS").chomp
    goarch = shell_output("#{go.opt_bin}/go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    (testpath/"hello.go").write <<~GO
      package main

      import (
          "fmt"

          "github.com/goplus/llgo/c"
      )

      func Foo() string {
        return "Hello LLGO by Foo"
      }

      func main() {
        fmt.Println("Hello LLGO by fmt.Println")
        c.Printf(c.Str("Hello LLGO by c.Printf\\n"))
      }
    GO
    (testpath/"hello_test.go").write <<~GO
      package main

      import "testing"

      func Test_Foo(t *testing.T) {
        got := Foo()
        want := "Hello LLGO by Foo"
        if got != want {
          t.Errorf("foo() = %q, want %q", got, want)
        }
      }
    GO
    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system go.opt_bin/"go", "get", "github.com/goplus/llgo"
    # Test llgo run
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n",
                 shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n",
                 shell_output("DYLD_LIBRARY_PATH=#{lib_deps.join(":")} ./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end
