class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/5f/82/b14e9226d11b606ec56af631beef422c4dfddb7a03b8906e53124f4a7079/pylint-2.10.2.tar.gz"
  sha256 "6758cce3ddbab60c52b57dcc07f0c5d779e5daf0cf50f6faacbef1d3ea62d2a1"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "33403d76452d60ac934468591aa720e734e9be185f05304ec4b020e297f3af71"
    sha256 cellar: :any_skip_relocation, big_sur:       "2c47258a377f74b2585e26ba2c3b1ce4081678a729889b49733ce6b55413f339"
    sha256 cellar: :any_skip_relocation, catalina:      "dc3d552bd7f83c6f78299a6568189f6bf3f09fb5b37ea578e6688cfecde87c9a"
    sha256 cellar: :any_skip_relocation, mojave:        "8316776d64de300b16e5286f9ca04684850eaace5934c6e88f95ad7f57c19633"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e0fd9bf1afd11310f291df69d43596acaa1661a08d9312265e2f5704844aa205"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/6f/94/88d24ff14d5e00e78ad7f940dec22d9e95234a2bbf1c16ebcfa19d761ac6/astroid-2.7.2.tar.gz"
    sha256 "b6c2d75cd7c2982d09e7d41d70213e863b3ba34d3bd4014e08f167cee966e99e"
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
    url "https://files.pythonhosted.org/packages/58/cb/ee4234464290e3dee893cf37d1adc87c24ade86ff6fc55f04a9bf9f1ec4f/platformdirs-2.2.0.tar.gz"
    sha256 "632daad3ab546bd8e6af0537d09805cec458dce201bccfe23012df73332e181e"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/be/ba/1f744cdc819428fc6b5084ec34d9b30660f6f9daaf70eead706e3203ec3c/toml-0.10.2.tar.gz"
    sha256 "b3bda1d108d5dd99f4a20d24d9c348e91c4db7ab1b749200bded2f839ccbe68f"
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
