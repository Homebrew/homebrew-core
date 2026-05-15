class Jello < Formula
  include Language::Python::Virtualenv

  desc "Filter JSON and JSON Lines data with Python syntax"
  homepage "https://github.com/kellyjonbrazil/jello"
  url "https://files.pythonhosted.org/packages/fb/5e/fe41641ce367cb8b57a6514372fffd7aed4a8c916cd7dc0bb7e9ae8f6ae2/jello-1.6.1.tar.gz"
  sha256 "eee1d43f2d9bb3b3b8c857b713e56191badb9a03a2274defaad1e727fad35521"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5e5564ce4d6f9a2095a9c16340ee5515b242d69d58c0e40a1b11203378507f65"
  end

  depends_on "python@3.14"

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
    man1.install "man/jello.1"
  end

  test do
    assert_equal "1\n", pipe_output("#{bin}/jello _.foo", "{\"foo\":1}")
  end
end
