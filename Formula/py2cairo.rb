class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"
  revision 1

  bottle do
    cellar :any
    sha256 "78ab70984d612ac9feba4d673615e3918110aebc4aa0b360a854e81fc7ac0ea7" => :catalina
    sha256 "f01c39e8f71339cdec156309fb7358f5bb3e292fb0a84a071c3a935b58234120" => :mojave
    sha256 "76dbdbbd42c2a59cae7e9ddc05ad26d331194c8a132e24e7316ceb551a40272b" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :macos # Due to Python 2

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
