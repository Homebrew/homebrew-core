class Goplus < Formula
  desc "Programming language for engineering, STEM education, and data science"
  homepage "https://goplus.org"
  url "https://github.com/goplus/gop/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "896ed4929e4cab246d3d03b06facb36c2a89d7a7c56b88e5d10d2d3d61d7cb45"
  license "Apache-2.0"
  head "https://github.com/goplus/gop.git", branch: "main"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 arm64_sonoma:   "2f932c859e9733e473895843605c2853dda925757cb3513022c05ad4990cbddb"
    sha256 arm64_ventura:  "05bc7f7d4ea654bcef00acc5f1e060060c4c3c805cfdf6963cbb19c717d9d31a"
    sha256 arm64_monterey: "b318f886db4103da85e8fffdee7912150364fb833ac61d3750ee59f11977ecc4"
    sha256 sonoma:         "5309d380fcca46541320615c3fdc6c05d766df38017acc7d1c67f693a8979bd9"
    sha256 ventura:        "62e340383e48bc9c956ec3b0d829bdd9fdf0dfeee335f720dd4e23b95bdf4150"
    sha256 monterey:       "f68fd3bdddfb4ce97cf1851820b7b56d193883db0693a869c2252e52f746fb39"
    sha256 x86_64_linux:   "bbef3483c5aee4078fe46462fb2c8197ad3850b9c7fe3f28f7448462b7a33581"
  end

  depends_on "go"

  def install
    ENV["GOPROOT_FINAL"] = libexec
    system "go", "run", "cmd/make.go", "--install"

    libexec.install Dir["*"] - Dir[".*"]
    bin.install_symlink Dir[libexec/"bin/*"]
  end

  test do
    (testpath/"hello.gop").write <<~EOS
      println("Hello World")
    EOS

    # Run gop fmt, run, build
    ENV.prepend "GO111MODULE", "on"

    assert_equal "v#{version}", shell_output("#{bin}/gop env GOPVERSION").chomp unless head?
    system bin/"gop", "fmt", "hello.gop"
    assert_equal "Hello World\n", shell_output("#{bin}/gop run hello.gop")

    (testpath/"go.mod").write <<~EOS
      module hello
    EOS

    system "go", "get", "github.com/goplus/gop/builtin"
    system bin/"gop", "build", "-o", "hello"
    assert_equal "Hello World\n", shell_output("./hello")
  end
end
