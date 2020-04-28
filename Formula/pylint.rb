class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/ff/ea/f4dada656f59cb60a223a5f4e83718f41ec82770f7f96b4b54140a4e5df9/pylint-2.5.0.tar.gz"
  sha256 "588e114e3f9a1630428c35b7dd1c82c1c93e1b0e78ee312ae4724c5e1a1e0245"

  bottle do
    cellar :any_skip_relocation
    sha256 "0b062d125fcf53cffa54ce4748b4045a0afae14786e97a63823d5d22e92cc637" => :catalina
    sha256 "ae12c952ed80a1d5a737e94ab0b5c4f14111b38099a98745fdcb3f018957f74d" => :mojave
    sha256 "b130a630d5fe4662dc363e727aceef2bbd491c274fcb3b70b5b3c47a6c0629f2" => :high_sierra
  end

  depends_on "python@3.8"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/c7/77/b63d5956ffaa237981fa99f902d1963f2c097c1dd9700447b4815dedceb9/astroid-2.4.0.tar.gz"
    sha256 "29fa5d46a2404d01c834fcb802a3943685f1fc538eb2a02a161349f5505ac196"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/43/00/8705e8d0c05ba22f042634f791a61f4c678c32175763dcf2ca2a133f4739/isort-4.3.21.tar.gz"
    sha256 "54da7e92468955c4fceacd0c86bd0ec997b0e1ee80d97f67c35a78b719dccab1"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/07/3f/a3d687f83c7d44970f70ff0400677746c8860b11f0c08f6b4e07205f0cdc/lazy-object-proxy-1.4.3.tar.gz"
    sha256 "f3900e8a5de27447acbf900b4750b0ddfd7ec1ea7fbaf11dfa911141bc522af0"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "six" do
    url "https://files.pythonhosted.org/packages/21/9f/b251f7f8a76dec1d6651be194dfba8fb8d7781d10ab3987190de8391d08e/six-1.14.0.tar.gz"
    sha256 "236bdbdce46e6e6a3d61a337c0f8b763ca1e8717c03b369e87a7ec7ce1319c0a"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/b9/19/5cbd78eac8b1783671c40e34bb0fa83133a06d340a38b55c645076d40094/toml-0.10.0.tar.gz"
    sha256 "229f81c57791a41d65e399fc06bf0848bab550a9dfd5ed66df18ce5f05e73d5c"
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
