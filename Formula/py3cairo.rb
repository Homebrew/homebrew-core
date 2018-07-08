class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.17.1/pycairo-1.17.1.tar.gz"
  sha256 "0f0a35ec923d87bc495f6753b1e540fd046d95db56a35250c44089fbce03b698"

  bottle do
    cellar :any
    sha256 "280b99f9e0a4814a309ef66e7ff6cae23c71779f518f24822ea0b3c898c1be8a" => :high_sierra
    sha256 "405530556a871cea9939e80448c93062b78d9f87eefbe7f43234e6b163713ecf" => :sierra
    sha256 "d19d935f41597232babbeef410fea14f9fb8ccbb1dd176e51bdfca1b1c0cb050" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on "python"

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
