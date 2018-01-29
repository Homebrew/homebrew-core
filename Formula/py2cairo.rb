class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.5/pycairo-1.15.5.tar.gz"
  sha256 "dbd11b2f41c71774f719887e3700bde69b9325a0664a3b616a559942dfbd3329"

  bottle do
    cellar :any
    sha256 "2a6dde2e434b97be988ba98b33e71d093dcdcd8e3a3899c43f53b4256838f8df" => :high_sierra
    sha256 "ca4cab7ea2d8483a45cff7bd9783a7fcb8d3f57f181834e5c8fda73d049d4182" => :sierra
    sha256 "04064f7c651b8aa3ef5fc6a2d700f90be24f181c13d0068339755cc03bdefe20" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python" if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
