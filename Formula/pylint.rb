class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/bd/8e/17dc5445c1614afe4df858c1d8ed2aedc5ec98e193527b78e3a19513e491/pylint-2.10.1.tar.gz"
  sha256 "9a699c8a5ecff651b2de6008f36cdffef95db9a9929a0559c3c3b9498b783897"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "fd34fefac850b0d4b49362b40e4cc30b1ea428687d965449c97f00842fc2ed67"
    sha256 cellar: :any_skip_relocation, big_sur:       "c163c1c84d79581a703e90cc1ebb316f511b04d50770702edbdc073c3750da22"
    sha256 cellar: :any_skip_relocation, catalina:      "62e8223d87c63c373c9e20e7b3d2d530f4e1f43461e923ce178810a9d2045bf0"
    sha256 cellar: :any_skip_relocation, mojave:        "8faed05e9fdb4b120941b736d91d9e60c777be629652b8650402d68094275751"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1bddca867f04c4b05cb155bc92f4d3eea0f47fdc354cabe1e1c0f24f7320c41f"
  end

  depends_on "python@3.9"

  resource "appdirs" do
    url "https://files.pythonhosted.org/packages/d7/d8/05696357e0311f5b5c316d7b95f46c669dd9c15aaeecbb48c7d0aeb88c40/appdirs-1.4.4.tar.gz"
    sha256 "7d5d0167b2b1ba821647616af46a749d1c653740dd0d2415100fe26e27afdf41"
  end

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
