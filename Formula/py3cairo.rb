class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.5/pycairo-1.15.5.tar.gz"
  sha256 "dbd11b2f41c71774f719887e3700bde69b9325a0664a3b616a559942dfbd3329"

  bottle do
    cellar :any
    sha256 "6e406c3d2a25243a94dc431943af690609c05e3c5f249aa92aaf50990a3f8bab" => :high_sierra
    sha256 "6a920f844ddc419ab1606ec5883dcde4591fd10d09df0db00e0c36f7c89c6579" => :sierra
    sha256 "f87c163a44a9600cd6a7cff663d49cac28262c02c71978353c880571f7046283" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python3"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
