class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/61/c0/752d9f4c506457f2f6969c3ea0e2d62809ac34d16e8d00502894f164bded/pylint-2.11.1.tar.gz"
  sha256 "2c9843fff1a88ca0ad98a256806c82c5a8f86086e7ccbdb93297d86c3f90c436"
  license "GPL-2.0-or-later"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d0d471720979cace6d8323f2012020a920d90543116fcc6f199d26996c974e3c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b5597a3045d478b630ec04f0762d8eadbce61e314c17df83b796590026017109"
    sha256 cellar: :any_skip_relocation, monterey:       "1131dcfcc116c886419a68c9873be00910e55d52ed963e21acd06aa3dd8fae9d"
    sha256 cellar: :any_skip_relocation, big_sur:        "0d78a3879c654cf8c1aa43c2ff41a210af891337dc62d78e56a8b2d14d57ae76"
    sha256 cellar: :any_skip_relocation, catalina:       "f5a39ecc62915323eaaf13510e6e4956fa3a0bd66d1a3b269198297fa241bd96"
    sha256 cellar: :any_skip_relocation, mojave:         "164c357745c60513d16497f7f02d024ba0fa02a86d32ead039423ebbb9e51a80"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60514c198e1161fbd059a5124fd200212000f6ed15ef8b3a4a67600cd8fd86c5"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/ac/d9/e64c49b9ef308505d7cb9f5e2b8e0af01933e7553c76b76d3dd183661428/astroid-2.8.0.tar.gz"
    sha256 "fe81f80c0b35264acb5653302ffbd935d394f1775c5e4487df745bf9c2442708"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/1c/34/ed9178b5b23ade4561bf77b91856e0e3bc094620fd81bd74d535817a0f0d/isort-5.9.3.tar.gz"
    sha256 "9c2ea1e62d871267b78307fe511c0838ba0da28698c5732d54e2790bf3ba9899"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/bb/f5/646893a04dcf10d4acddb61c632fd53abb3e942e791317dcdd57f5800108/lazy-object-proxy-1.6.0.tar.gz"
    sha256 "489000d368377571c6f982fba6497f2aa13c6d1facc40660963da62f5c379726"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/e2/d4/c6ffe89de09851892b1418dc22f6ab019b7b6f362532ab813c262e1722bb/platformdirs-2.3.0.tar.gz"
    sha256 "15b056538719b1c94bdaccb29e5f81879c7f7f0f4a153f46086d155dffcd4f0f"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
  end

  resource "typing-extensions" do
    url "https://files.pythonhosted.org/packages/ed/12/c5079a15cf5c01d7f4252b473b00f7e68ee711be605b9f001528f0298b98/typing_extensions-3.10.0.2.tar.gz"
    sha256 "49f75d16ff11f1cd258e1b988ccff82a3ca5570217d7ad8c5f48205dd99a677e"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/82/f7/e43cefbe88c5fd371f4cf0cf5eb3feccd07515af9fd6cf7dbf1d1793a797/wrapt-1.12.1.tar.gz"
    sha256 "b62ffa81fb85f4332a4f609cab4ac40709470da05643a082ec1eb88e6d9b97d7"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
