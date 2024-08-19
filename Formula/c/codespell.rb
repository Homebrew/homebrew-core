class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/a0/a9/98353dfc7afcdf18cffd2dd3e959a25eaaf2728cf450caa59af89648a8e4/codespell-2.3.0.tar.gz"
  sha256 "360c7d10f75e65f67bad720af7007e1060a5d395670ec11a7ed1fed9dd17471f"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "7d8ac836da4bf14f2e685147360215b2b476fc63fbf9bc37979fd4430ee1b202"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0dc7f90fadd9e39733dc88ff59f52cba19e581a1e9933511a07032a6236a73ec"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "af686610c54cdd3c8f6fadac7bc52cdae5cbaffe434f1099893a27eb8ddb8634"
    sha256 cellar: :any_skip_relocation, sonoma:         "f5d16e50196edd7ae031e2da5d94c940879e5ae5fe05714d128d5217facb1050"
    sha256 cellar: :any_skip_relocation, ventura:        "94160bac658c1549d5cdc5b164cbe766a86ee9e7b23b2650ba1ce791f877833a"
    sha256 cellar: :any_skip_relocation, monterey:       "dc0dfbdbd433b7e779f7b7bd918e15bb1442996b891adefa092bcafc82fbc05b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a80a9c57378d5c347ca1695b3ddf0ecd63d507ee9e1d1ab6fd1d2f1e6957e6a5"
  end

  depends_on "python@3.12"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", pipe_output("#{bin}/codespell -", "teh", 65)
  end
end
