class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.17.0/pycairo-1.17.0.tar.gz"
  sha256 "cdd4d1d357325dec3a21720b85d273408ef83da5f15c184f2eff3212ff236b9f"
  revision 1

  bottle do
    cellar :any
    sha256 "9cd76508b8b60e33429513c36bb979ab733e46158f3dcfca6aad8da94029307b" => :high_sierra
    sha256 "50f1e3f493dafbcad4d213269d34615d50d59e34ad9e6f0e8a13ba2842d10eb0" => :sierra
    sha256 "5af596a6cd1e526989af5a81f7598e3fd500635f2f736ddb5d1f13a0d8d09d96" => :el_capitan
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
