class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.9.9.tar.gz"
  sha256 "705fed97ef8b337863fd9bbb40653c22fd93ba689f879db06801d37e5d8fe809"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sequoia: "e4f7a4e54a80876defc9ef22d779e0043f897c3dd146efb4494a4dac722018f1"
    sha256 cellar: :any, arm64_sonoma:  "e302707dcf587e2526f815f75dc9a25f571b09621ccf5245743899b452f2bc07"
    sha256 cellar: :any, arm64_ventura: "4b4c2d0f8f722bc2c4053bd34bceb98d97e52a8068bda9b07a33366ca684e768"
    sha256 cellar: :any, sonoma:        "67851d672f74c74b34652788de4175098dc1636b717c97574e5bcc804af5241f"
    sha256 cellar: :any, ventura:       "66fe74269b0f47db75f1d5c283f8dda84166d7d95be5b225e2be458c40a99d5e"
    sha256               x86_64_linux:  "f90f9374df031d8dcf2a554da1226937d77e1e71c82ae77b583afaa72f56769a"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm@18"
  depends_on "openssl@3"
  depends_on "pkgconf"

  def llvm
    deps.map(&:to_formula).find { |f| f.name.match?(/^llvm(@\d+)?$/) }
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
      -X github.com/goplus/llgo/x/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/x/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{llvm.opt_bin/"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec/"bin/", "./cmd/llgo"

    libexec.install "LICENSE", "README.md"

    path = llvm.opt_bin + ":" + %w[go pkgconf].map { |f| Formula[f].opt_bin }.join(":")
    opt_lib = %w[bdw-gc openssl@3].map { |f| Formula[f].opt_lib }.join(":")

    (libexec/"bin").children.each do |f|
      next if f.directory?

      cmd = File.basename(f)
      (bin/cmd).write_env_script libexec/"bin"/cmd,
        PATH:            "#{path}:$PATH",
        LD_LIBRARY_PATH: "#{opt_lib}:$LD_LIBRARY_PATH"
    end
  end

  test do
    opt_lib = %w[bdw-gc openssl@3].map { |f| Formula[f].opt_lib }.join(":")
    ENV.prepend_path "LD_LIBRARY_PATH", opt_lib

    goos = shell_output(Formula["go"].opt_bin/"go env GOOS").chomp
    goarch = shell_output(Formula["go"].opt_bin/"go env GOARCH").chomp
    assert_equal "llgo v#{version} #{goos}/#{goarch}", shell_output("#{bin}/llgo version").chomp

    (testpath/"hello.go").write <<~GO
      package main

      import "github.com/goplus/llgo/c"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    GO
    (testpath/"go.mod").write <<~GOMOD
      module hello
    GOMOD
    system Formula["go"].opt_bin/"go", "get", "github.com/goplus/llgo@v#{version}"
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output("./hello")
  end
end
