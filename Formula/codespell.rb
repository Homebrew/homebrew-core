class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/f3/d1/0553aad57ca850516c2a666690fd818fa9e80f1293e460be976eee4dcc86/codespell-2.0.0.tar.gz"
  sha256 "dd9983e096b9f7ba89dd2d2466d1fc37231d060f19066331b9571341363c77b8"
  license "GPL-2.0-only"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "fcb75db588b0ee07820cea9623c54047317c259a3b7fcee2c2790df94edbbf09" => :big_sur
    sha256 "4cb15e19443191ba519e77ae1503e645096fe38cebc29425f7aab0c1da0c0e96" => :catalina
    sha256 "d2d93078208cbf498d4f18e6c7f1096a33b70ea00d8f7ef5e556150842d1c4fc" => :mojave
    sha256 "5e533ea4ed12daf3435849cc585f880da3ef80edc51131e5b601dc91a41c5120" => :high_sierra
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 65)
  end
end
