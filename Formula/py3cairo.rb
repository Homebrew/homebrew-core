class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.2/pycairo-1.15.2.tar.gz"
  sha256 "a66f30c457736f682162e7b3a33bc5e8915c0f3b31ef9bdb4edf43c81935c914"

  bottle do
    cellar :any
    sha256 "f0e12ea1b4f9aec69b7762ec3bb387b13d6abc7c02ff70e9d024c9cc49b7e027" => :sierra
    sha256 "3991534de1d9542bef1dd191364ebf5ce22cc32debbbc5333ebc42bbbbc50b30" => :el_capitan
    sha256 "0a6c13d9827824e995914eab59ea1437ca7cae5b7cd8dd78b5e92e61bba4821d" => :yosemite
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python3

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
