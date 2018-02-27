class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.3/pycairo-1.16.3.tar.gz"
  sha256 "5bb321e5d4f8b3a51f56fc6a35c143f1b72ce0d748b43d8b623596e8215f01f7"
  revision 1

  bottle do
    cellar :any
    sha256 "7cd40b2ced6fa6f2781c86fa006a3694a5583ba01074978b1b266b58644c6c49" => :high_sierra
    sha256 "e592f410be4ef2cdc8ae9223e2b4ad1d4a1655b9aaaf5647e68616583aa44bcf" => :sierra
    sha256 "af67053ed300f16c5db17b63847b2710ed802776f0baaac9058b9412505dd5ce" => :el_capitan
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
