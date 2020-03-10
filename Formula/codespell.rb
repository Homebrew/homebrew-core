class Codespell < Formula
  include Language::Python::Virtualenv

  desc "Fix common misspellings in source code and text files"
  homepage "https://github.com/codespell-project/codespell"
  url "https://files.pythonhosted.org/packages/df/6f/764ca059e0eb06b69e1abed2c9a2cabe7dac72b336e2600615b38ea547a3/codespell-1.16.0.tar.gz"
  sha256 "bf3b7c83327aefd26fe718527baa9bd61016e86db91a8123c0ef9c150fa02de9"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "e5bd38be2a2e19da270f6f547efcfdb325418d4554e5572ecf9070f05a6fa0cd" => :catalina
    sha256 "8d648259f31feb6afa58958f64daf6cd681382ea0cb9a0c4024bec7913502ab7" => :mojave
    sha256 "4f501e0bc4df951622b9748d11df1b14dadf1d5fa1e79bb11bd49c51f61caa8b" => :high_sierra
  end

  depends_on "python@3.8"

  def install
    virtualenv_install_with_resources
  end

  test do
    assert_equal "1: teh\n\tteh ==> the\n", shell_output("echo teh | #{bin}/codespell -", 1)
  end
end
