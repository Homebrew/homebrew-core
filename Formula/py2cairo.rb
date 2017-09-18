class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.3/pycairo-1.15.3.tar.gz"
  sha256 "8642e36cef66acbfc02760d2b40c716f5f183d073fb063ba28fd29a14044719d"

  bottle do
    cellar :any
    sha256 "6cc07da4276294a5cf82efda7e4d3c5c25de137e76b3928d8c831631512ac8d0" => :sierra
    sha256 "a9fce1abe4f466d2a8be3a0477fd8e1851c913615898dd8f80e2143da7f09f47" => :el_capitan
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
