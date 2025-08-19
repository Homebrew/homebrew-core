class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/luoliwoshang/llgo"
  url "https://github.com/luoliwoshang/llgo/archive/refs/tags/v0.12.7.tar.gz"
  sha256 "a3a8c8095be50dcc8f13a379617399eb820815063b471c6284a060198298c652"
  license "Apache-2.0"
  head "https://github.com/luoliwoshang/llgo.git", branch: "internal/build/rpath"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any, arm64_sequoia: "b10ff1d39f288838a7b5a13a63a3e16804d8ea628cdfd6696f0af887433971fc"
    sha256 cellar: :any, arm64_sonoma:  "d0754d188737c058658ed2a70dc35766fcda1749dfe5e95f546179d33c4fd8ea"
    sha256 cellar: :any, arm64_ventura: "915d149d72ed455e7a710084ce4b2b7717354c11080a7d908b1ae55b010f14cf"
    sha256 cellar: :any, sonoma:        "bf3b8f7feffaaaeb6db5553b06276f0d16e659395f5190ff2e41833c5f237c17"
    sha256 cellar: :any, ventura:       "5a52937041fcdcdc649157cd0f8493737d6988d1213ad1d664a63fca8153c2ff"
    sha256               x86_64_linux:  "90b74a9797489b39973dbc58bf1abfaf1a88018be88665517fdd309f91b38e14"
  end

  depends_on "bdw-gc"
  depends_on "go@1.24"
  depends_on "libffi"
  depends_on "libuv"
  depends_on "lld@19"
  depends_on "llvm@19"
  depends_on "openssl@3"
  depends_on "pkgconf"
  uses_from_macos "zlib"

  def find_dep(name)
    deps.map(&:to_formula).find { |f| f.name.match?(/^#{name}(@\d+)?$/) }
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

    path_deps = %w[lld llvm go pkgconf].map { |name| find_dep(name).opt_bin }
    script_env = { PATH: "#{path_deps.join(":")}:$PATH" }

    if OS.linux?
      script_env[:CFLAGS] = "-I#{llvm.opt_include} $CFLAGS"
      script_env[:LDFLAGS] = "-L#{llvm.opt_lib} -rpath #{llvm.opt_lib} $LDFLAGS"
    end

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd, script_env
    end
  end

  test do
    goos = shell_output("go env GOOS").chomp
    goarch = shell_output("go env GOARCH").chomp
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
          "github.com/goplus/lib/cpp/std"
      )

      func Foo() string {
        return "Hello LLGO by Foo"
      }

      func main() {
        fmt.Println("Hello LLGO by fmt.Println")
        c.Printf(c.Str("Hello LLGO by c.Printf\\n"))
        c.Printf(std.Str("Hello LLGO by cpp/std.Str\\n").CStr())
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
    system "go", "get", "github.com/goplus/lib"
    # Test llgo run
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n" \
                 "Hello LLGO by cpp/std.Str\n",
                 shell_output("#{bin}/llgo run .")
    # Test llgo build
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO by fmt.Println\n" \
                 "Hello LLGO by c.Printf\n" \
                 "Hello LLGO by cpp/std.Str\n",
                 shell_output("./hello")
    # Test llgo test
    assert_match "PASS", shell_output("#{bin}/llgo test .")
  end
end
