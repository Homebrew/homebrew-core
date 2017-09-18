class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.3/pycairo-1.15.3.tar.gz"
  sha256 "8642e36cef66acbfc02760d2b40c716f5f183d073fb063ba28fd29a14044719d"

  bottle do
    cellar :any
    sha256 "1827859a094a9fe5411145f2181c7d27433b3de6b44bcc6231bfb05008c84198" => :high_sierra
    sha256 "4cf4016ebd9f4083fccfacd4f215fe0e94a88960aafa9cd94cca37a5c7f894e8" => :sierra
    sha256 "544a3398f66639aadfdfe2498d0da95622de07ef8aedb734aa867b490c60f178" => :el_capitan
  end

  depends_on "pkg-config" => :build
  depends_on "cairo"
  depends_on :python3

  def install
    system "python3", *Language::Python.setup_install_args(prefix)
  end

  test do
    system "python3", "-c", "import cairo; print(cairo.version)"
  end
end
