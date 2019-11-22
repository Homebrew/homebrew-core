class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"

  bottle do
    cellar :any
    sha256 "e7d33dfe96f2aafdcc895e211aff9691c030126ae717ca1e8c845f3d0100ca72" => :catalina
    sha256 "a1dbbca0c6a9d8f0f0a43ccfc3827f4209c834da8dd03f2c8f98aff5d3b76dd5" => :mojave
    sha256 "3f333bfd82a7ecdbcd25fddf0ebcf99b00a34a4084523c3eccdb4716fe9940fb" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python@2"

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
