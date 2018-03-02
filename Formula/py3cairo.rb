class Py3cairo < Formula
  desc "Python 3 bindings for the Cairo graphics library"
  homepage "https://cairographics.org/pycairo/"
  url "https://github.com/pygobject/pycairo/releases/download/v1.16.3/pycairo-1.16.3.tar.gz"
  sha256 "5bb321e5d4f8b3a51f56fc6a35c143f1b72ce0d748b43d8b623596e8215f01f7"
  revision 1

  bottle do
    cellar :any
    sha256 "408a5438d3374a087dc9aee9b0227f116f07da9f338d3d17e6b103e303ff4070" => :high_sierra
    sha256 "1b1380ca5cbb8a16522664aa5a1d5e40bef1214215a86ba4c3cc925d9b23d277" => :sierra
    sha256 "4603f0ef30b9d4eac6c70643602ed80d469482b4177b6011b2fb738dbcca5613" => :el_capitan
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
