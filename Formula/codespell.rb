class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/df/6f/764ca059e0eb06b69e1abed2c9a2cabe7dac72b336e2600615b38ea547a3/codespell-1.16.0.tar.gz"
  sha256 "bf3b7c83327aefd26fe718527baa9bd61016e86db91a8123c0ef9c150fa02de9"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "99881ae6b8146c6d2f1920ebe38326ec956fb6f373e0a24e0edb752aba542b39" => :catalina
    sha256 "5a03b3a7c8ee14881fa1ea4b67704d0669f67947ea4dce63e559563105d9d811" => :mojave
    sha256 "adf3d2cb26a64b62a1cd57a380330bf5328aa49a8591668445e212d970c820d0" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
