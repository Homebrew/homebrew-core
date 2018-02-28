class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.3/pycairo-1.16.3.tar.gz"
  sha256 "5bb321e5d4f8b3a51f56fc6a35c143f1b72ce0d748b43d8b623596e8215f01f7"

  bottle do
    cellar :any
    sha256 "e687f48040be3abc87648271a1f80580d79ecac73f0a5c2261d3973f24c59652" => :high_sierra
    sha256 "8aef6503ecaa21895abdb1b94e9401350bb6a5de8c81b37185360e061ce68942" => :sierra
    sha256 "967664febee0fde9a33928b795e5fbb123b38f9a5b6ea5a119168867ce7451cf" => :el_capitan
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
