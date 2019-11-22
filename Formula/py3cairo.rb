class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.18.2/pycairo-1.18.2.tar.gz"
  sha256 "dcb853fd020729516e8828ad364084e752327d4cff8505d20b13504b32b16531"

  bottle do
    cellar :any
    sha256 "6677109a62ba0067b4da18eaa3b49fa7046602787563ef9070c01770e8b9317c" => :catalina
    sha256 "d11fba86f2d505548d02700480cb6a9791b3c5e7d973c17fbf5b70f79492fa01" => :mojave
    sha256 "080b8420adc3a72c4f140d0149300b4f97eceee6e06ada4ffff15fa79cbaa099" => :high_sierra
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
