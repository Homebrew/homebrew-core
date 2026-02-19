class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/fb/5e/fe41641ce367cb8b57a6514372fffd7aed4a8c916cd7dc0bb7e9ae8f6ae2/jello-1.6.1.tar.gz"
  sha256 "eee1d43f2d9bb3b3b8c857b713e56191badb9a03a2274defaad1e727fad35521"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "851ca4782d37f715f8e522040d2aa8c9e7fbc948da3f42f43e653778432eb291"
  end

  depends_on "python@3.14"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/b0/77/a5b8c569bf593b0140bde72ea885a803b82086995367bf2037de0159d924/pygments-2.19.2.tar.gz"
    sha256 "636cb2477cec7f8952536970bc533bc43743542f70392ae026374600add5b887"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
