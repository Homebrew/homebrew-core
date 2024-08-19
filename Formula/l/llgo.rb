class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.9.6.tar.gz"
  sha256 "2b88b7d088a88e61d0776e7a3e70b418bfb09af0e4140275ed35141658db8e83"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any, arm64_sonoma:   "1f28451ef983844e57e836cd7fb9637fd8f9c9f8fbecd596d78d858fc3d2172e"
    sha256 cellar: :any, arm64_ventura:  "5e94831ddbb74021b91f446ad5871742fd6a62a71810a8debe7622569374e049"
    sha256 cellar: :any, arm64_monterey: "fdd1baa035e6a92a5f6c708e2b55cc8824b55a0b0d403fa196112ea5c03cb70c"
    sha256 cellar: :any, sonoma:         "0e96026933f1157e844e36f28c8832593124d523b6cd293c42383e69e40d7590"
    sha256 cellar: :any, ventura:        "f2a4119581dd5bbaf8d33561edbec6b5fe2051de4b78b83bf41660cdb6f3f069"
    sha256 cellar: :any, monterey:       "9cf5a78bedce3d955cbb33730599a165404863784583c8098484b3c224dc72da"
    sha256               x86_64_linux:   "0ddb79429e4f5e455d72f69674eaab0d10505d0c22cf1f5c35543a9ef9f45490"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm"
  depends_on "openssl@3"
  depends_on "pkg-config"

  def install
    if OS.linux?
      ENV.prepend "CGO_CPPFLAGS",
        "-I#{Formula["llvm"].opt_include} " \
        "-D_GNU_SOURCE " \
        "-D__STDC_CONSTANT_MACROS " \
        "-D__STDC_FORMAT_MACROS " \
        "-D__STDC_LIMIT_MACROS"
      ENV.prepend "CGO_LDFLAGS", "-L#{Formula["llvm"].opt_lib} -lLLVM"
    end

    ldflags = %W[
      -s -w
      -X github.com/goplus/llgo/x/env.buildVersion=v#{version}
      -X github.com/goplus/llgo/x/env.buildTime=#{time.iso8601}
      -X github.com/goplus/llgo/xtool/env/llvm.ldLLVMConfigBin=#{Formula["llvm"].opt_bin/"llvm-config"}
    ]
    build_args = *std_go_args(ldflags:)
    build_args += ["-tags", "byollvm"] if OS.linux?
    system "go", "build", *build_args, "-o", libexec/"bin/", "./cmd/llgo"

    libexec.install "LICENSE", "README.md"

    path = %w[go llvm pkg-config].map { |f| Formula[f].opt_bin }.join(":")
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

    (testpath/"hello.go").write <<~EOS
      package main

      import "github.com/goplus/llgo/c"

      func main() {
        c.Printf(c.Str("Hello LLGO\\n"))
      }
    EOS
    (testpath/"go.mod").write <<~EOS
      module hello
    EOS
    system Formula["go"].opt_bin/"go", "get", "github.com/goplus/llgo@v#{version}"
    system bin/"llgo", "build", "-o", "hello", "."
    assert_equal "Hello LLGO\n", shell_output("./hello")
  end
end
