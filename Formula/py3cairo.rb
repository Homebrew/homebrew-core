class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.15.4/pycairo-1.15.4.tar.gz"
  sha256 "ee4c3068c048230e5ce74bb8994a024711129bde1af1d76e3276c7acd81c4357"
  revision 1

  bottle do
    cellar :any
    sha256 "59c42199630db8cf62329d804669d56efabc98ac476e01511b40f72e0f781756" => :high_sierra
    sha256 "57ac45f5e597588478ed3c1eeda5f1918d11816a7fb29396add5616c7f86d89a" => :sierra
    sha256 "d1315a45a52290fbffd8ecd7a21f05c36a21fc50110a0f63a4a11caa736faa22" => :el_capitan
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
