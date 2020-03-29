class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/93/eb/851ab1d1ca6b37babd326dfa517b432963c54eda26c730353306aa0cdf4d/pylint-2.4.4.tar.gz"
  sha256 "3db5468ad013380e987410a8d6956226963aed94ecb5f9d3a28acca6d9ac36cd"
  revision 2

  bottle do
    cellar :any_skip_relocation
    sha256 "0b062d125fcf53cffa54ce4748b4045a0afae14786e97a63823d5d22e92cc637" => :catalina
    sha256 "ae12c952ed80a1d5a737e94ab0b5c4f14111b38099a98745fdcb3f018957f74d" => :mojave
    sha256 "b130a630d5fe4662dc363e727aceef2bbd491c274fcb3b70b5b3c47a6c0629f2" => :high_sierra
  end

  depends_on "python@3.8"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/40/df/70dfe3eed7352dd3f5c7cc74518ceed78230b2ca9d7d60dbabd81d5390ba/astroid-2.3.3.tar.gz"
    sha256 "71ea07f44df9568a75d0f354c49143a4575d90645e9fead6dfb52c26a85ed13a"
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
    url "https://files.pythonhosted.org/packages/94/3e/edcf6fef41d89187df7e38e868b2dd2182677922b600e880baad7749c865/six-1.13.0.tar.gz"
    sha256 "30f610279e8b2578cab6db20741130331735c781b56053c59c4076da27f06b66"
  end

  resource "typed-ast" do
    url "https://files.pythonhosted.org/packages/34/de/d0cfe2ea7ddfd8b2b8374ed2e04eeb08b6ee6e1e84081d151341bba596e5/typed_ast-1.4.0.tar.gz"
    sha256 "66480f95b8167c9c5c5c87f32cf437d585937970f3fc24386f313a4c97b44e34"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/23/84/323c2415280bc4fc880ac5050dddfb3c8062c2552b34c2e512eb4aa68f79/wrapt-1.11.2.tar.gz"
    sha256 "565a021fd19419476b9362b05eeaa094178de64f8361e44468f9e9d7843901e1"
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
