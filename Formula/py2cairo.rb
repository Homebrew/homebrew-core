class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.0/pycairo-1.18.0.tar.gz"
  sha256 "abd42a4c9c2069febb4c38fe74bfc4b4a9d3a89fea3bc2e4ba7baff7a20f783f"

  bottle do
    cellar :any
    sha256 "8bd3de2a1d208ec5604e86c215b1ceae79363efd969e8693c27d73a4948b0c37" => :mojave
    sha256 "cc27ae0fe2cb2fc727536d20f61570ae84e44e25091d597f90998da561df2ae4" => :high_sierra
    sha256 "aaf3782651fff409434c559defc6ccc043d7070ae1dae4dcf5e9c42fb7c72430" => :sierra
    sha256 "13175f0338beb6d0253974f01422fcbbb3cb3b47d43af1a51689dd1f803e62d8" => :el_capitan
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
