class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://cairographics.org/releases/pycairo-1.10.0.tar.bz2"
  mirror "https://distfiles.macports.org/py-cairo/pycairo-1.10.0.tar.bz2"
  sha256 "9aa4078e7eb5be583aeabbe8d87172797717f95e8c4338f0d4a17b683a7253be"
  revision 2

  bottle do
    cellar :any
    rebuild 1
    sha256 "4c09c892ebd8cbb783d9191b055b30f7b45ae2048dfaef9754c26e0f9d49b22b" => :sierra
    sha256 "3e853d8591df79acdd2406fb0696f136ef27de7064b4383827180c423b2e167b" => :el_capitan
    sha256 "679305655b5d1453e338dac356d81c42796313fc1092cdcdef01f5f2e53e6043" => :yosemite
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
