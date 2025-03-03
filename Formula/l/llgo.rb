class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.10.0.tar.gz"
  sha256 "a47af34904645ddf26d69018a7b44ec0350f41b1a860bd1d8f4bddebc27cde80"
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
