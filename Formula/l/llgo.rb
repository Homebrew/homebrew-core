class Llgo < Formula
  desc "Go compiler based on LLVM integrate with the C ecosystem and Python"
  homepage "https://github.com/goplus/llgo"
  url "https://github.com/goplus/llgo/archive/refs/tags/v0.9.7.tar.gz"
  sha256 "f9721be0b41d1e622923b4aa1d4e8071af93753f36f4c9285697e6af009fa0dc"
  license "Apache-2.0"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_sequoia: "c2843ed4c34662cd4efb4332efc801ebd481623ccc1cff1448be0804ad197038"
    sha256 cellar: :any, arm64_sonoma:  "02e5fbd91b3ec0560cd653cd113eaff7d7899521fe56efb95bf76da703e88c9f"
    sha256 cellar: :any, arm64_ventura: "ee9649478a6a5327d9c7c28880b1cf203cdc4e88c09cc59ce9d8f06e275749db"
    sha256 cellar: :any, sonoma:        "1a21fcc15688f58e760474cb36700411865591f1dc88608a7434866017af43ae"
    sha256 cellar: :any, ventura:       "50fd0b364c4ff977f5bc1c64d54a048dce67fcc06e12a0fb228cb2f2d6eabce0"
    sha256               x86_64_linux:  "ec6fb4fdba58e39f7008ffa6311278e155a7e37856c78b88e953afa4f0a61cec"
  end

  depends_on "bdw-gc"
  depends_on "go"
  depends_on "llvm@18"
  depends_on "openssl@3"
  depends_on "pkg-config"

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

    path = llvm.opt_bin + ":" + %w[go pkg-config].map { |f| Formula[f].opt_bin }.join(":")
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
