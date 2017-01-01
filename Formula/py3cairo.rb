class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 3

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
    ENV["PYTHON"] = "python3"
    system "./waf", "configure", "--prefix=#{prefix}"
    system "./waf", "build"
    system "./waf", "install"
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
