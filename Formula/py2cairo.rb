class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz"
  sha256 "0f0a35ec923d87bc495f6753b1e540fd046d95db56a35250c44089fbce03b698"

  bottle do
    cellar :any
    sha256 "64252ff78ad4788c18dd26bbf0b61a20a51082181690e765e509effd1e51805d" => :high_sierra
    sha256 "bb9628ce0a22cae5da990abd888f654d426dab7f826ef60131b9a0dcdb2d28a1" => :sierra
    sha256 "bc3f44f331d646a319537b800a75232534c33049ae399d6ff41aa9d3c410b02c" => :el_capitan
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
