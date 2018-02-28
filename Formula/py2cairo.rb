class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.3/pycairo-1.16.3.tar.gz"
  sha256 "5bb321e5d4f8b3a51f56fc6a35c143f1b72ce0d748b43d8b623596e8215f01f7"

  bottle do
    cellar :any
    sha256 "3f24bd2b298d6ac93a00f6c4eb15cf974586748bc2b652e441d99ab055c59989" => :high_sierra
    sha256 "4a5e1a24733f1a4acc54e4707824deb18ecae7e5655b7b3d75abc925b6c875bf" => :sierra
    sha256 "ff201acad4e8bcaac84098a83d2ff32c182074b7eb095836492c6cc9094650a0" => :el_capitan
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
