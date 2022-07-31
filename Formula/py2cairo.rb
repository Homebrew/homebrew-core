class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"
  license "LGPL-2.1"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_monterey: "ed5c4e9b343a02fb4e38460eb787a72d5c712796ecb9ca7619b9bcb1545e8e04"
    sha256 cellar: :any, arm64_big_sur:  "de68fca224353b7e7b8426e24324fdb6fd0cc5a6180db4ad0ccd02b43919b0bc"
    sha256 cellar: :any, monterey:       "e0f4ec3c7a76d356bde27fdab4ea8cb742931f80d3aac47ddea5a82f727bd32b"
    sha256 cellar: :any, big_sur:        "80feea24d8039acef848c76075f8911493762d75b883b56bf4d87f14d5a3bbac"
    sha256 cellar: :any, catalina:       "78ab70984d612ac9feba4d673615e3918110aebc4aa0b360a854e81fc7ac0ea7"
    sha256 cellar: :any, mojave:         "f01c39e8f71339cdec156309fb7358f5bb3e292fb0a84a071c3a935b58234120"
    sha256 cellar: :any, high_sierra:    "76dbdbbd42c2a59cae7e9ddc05ad26d331194c8a132e24e7316ceb551a40272b"
  end

  # Python 2 support was dropped in version 1.19.0 and this formula is pinned
  # to the last preceding version.
  disable! date: "2022-07-31", because: :versioned_formula

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
