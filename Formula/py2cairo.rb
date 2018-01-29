class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.5/pycairo-1.15.5.tar.gz"
  sha256 "dbd11b2f41c71774f719887e3700bde69b9325a0664a3b616a559942dfbd3329"

  bottle do
    cellar :any
    sha256 "dcfb20e334e44bcfc034be0f14eb9331f4c5fac7d7d347974937f62e62ac5d0a" => :high_sierra
    sha256 "5bb3c4d5196dfeb83d2cfc13db13db1410ca68baf63fb9b6b839f634c08228ea" => :sierra
    sha256 "75692321a14e8e7ca48ef1fb90fda57343d1ae9bfc87f248219c61271eb8f22f" => :el_capitan
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
