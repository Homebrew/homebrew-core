class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.1/pycairo-1.16.1.tar.gz"
  sha256 "47a14a6a2f8dadb649229f099ac712a5f3d0a22e14877165a203d8a0de09ad63"

  bottle do
    cellar :any
    sha256 "b3fff7fdd1ab7804daef1ec88fbd2f7db09235722a8d4c2cb4839321ecf76966" => :high_sierra
    sha256 "b3678d68cbf0bbd696180ca4fcab42f8cfca4f14e3438cd790d78a3dcbe23a85" => :sierra
    sha256 "a4c52dc1c2eef210bbe72971770a304ca14dc10396fc97284b981ace84d2826f" => :el_capitan
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
