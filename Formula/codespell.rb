class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/7e/37/b15b4133e90bbef5acecfd2f3f3871c1352ee281c042fd64a22a72735fb8/codespell-1.17.1.tar.gz"
  sha256 "25a2ecd86b9cdc111dc40a30d0ed28c578e13a0ce158d1c383f9d47811bfcd23"
  license "GPL-2.0"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4cb15e19443191ba519e77ae1503e645096fe38cebc29425f7aab0c1da0c0e96" => :catalina
    sha256 "d2d93078208cbf498d4f18e6c7f1096a33b70ea00d8f7ef5e556150842d1c4fc" => :mojave
    sha256 "5e533ea4ed12daf3435849cc585f880da3ef80edc51131e5b601dc91a41c5120" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
