class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.3/pycairo-1.15.3.tar.gz"
  sha256 "8642e36cef66acbfc02760d2b40c716f5f183d073fb063ba28fd29a14044719d"

  bottle do
    cellar :any
    sha256 "01c91b2b1c8596257245254bfc1a6f1811f4e803fc297f483ef8d017ef82e43a" => :high_sierra
    sha256 "82527cf1e89d40dd7de844fd8cadbae4a900ad893a3c4e8f1650e5e1d3919ef9" => :sierra
    sha256 "6e1c76ef746665c9bc20a0cc1b19ebaee9bf07b343cdb4de84f0687e6f28001d" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python if MacOS.version <= :snow_leopard

  def install
    system "python", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python", "-c", "import cairo; print(cairo.version)"
  end
end
