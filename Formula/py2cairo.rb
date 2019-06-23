class Py2cairo < Formula
  desc "Python 2 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.1/pycairo-1.18.1.tar.gz"
  sha256 "70172e58b6bad7572a3518c26729b074acdde15e6fee6cbab6d3528ad552b786"

  bottle do
    cellar :any
    sha256 "46599e5f1abc91308b81ff7c8dea1df675ffc7349f0953aae40742f450e54932" => :mojave
    sha256 "a20fd135bf7242a1978cda0d4dfdba2529875bc476ed3322f407832a9ce04445" => :high_sierra
    sha256 "1ff1752697e067f46f10923d234e7352b6f68254faaa630a173ce3a6b50ca8c0" => :sierra
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
