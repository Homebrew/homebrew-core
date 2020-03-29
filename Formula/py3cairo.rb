class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.19.1/pycairo-1.19.1.tar.gz"
  sha256 "2c143183280feb67f5beb4e543fd49990c28e7df427301ede04fc550d3562e84"

  bottle do
    cellar :any
    sha256 "16e8624d831989d60f783a0b1a5b1462b381066ce87eeb9777a4169246b928eb" => :catalina
    sha256 "9adc53923bbb3e34ecf74feaaf74697d683580ecd1c76ede34f794e9d211f029" => :mojave
    sha256 "534894edb2877f7850462b50af43f260602538e56e3c9aba8289b42c26aba609" => :high_sierra
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
