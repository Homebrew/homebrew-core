class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.1/pycairo-1.18.1.tar.gz"
  sha256 "70172e58b6bad7572a3518c26729b074acdde15e6fee6cbab6d3528ad552b786"

  bottle do
    cellar :any
    sha256 "78631983372e2d3916edcd85c0ad5b06e2f1ef37bfd4437d056c89408de64ac1" => :catalina
    sha256 "c3d966320ca66c24c01fa3dd2dd867329e9b6d817895fc5466b8280ea806d093" => :mojave
    sha256 "f285ea47d9693b403080decdc94c0ae60364ec554c44a61473480ca0f420ebc3" => :high_sierra
    sha256 "099809cc80cfd67838454bc57787ca647d2c1b52c6bdea17c317bc9797ac4cd6" => :sierra
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
