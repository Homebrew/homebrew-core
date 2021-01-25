class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/24/4a/a07484119d23283de4d8db8176e85be3b20583eefc1cbfa8363b1414fbe2/pylint-2.6.0.tar.gz"
  sha256 "bb4a908c9dadbc3aac18860550e870f58e1a02c9f2c204fdf5693d73be061210"
  license "GPL-2.0-or-later"
  revision 1

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5bfed263aeab29b095c6444dfcfaa6f4d274fb64e879b49a861390d541d9e7d5" => :big_sur
    sha256 "36d38ff773fd914b3314302906f65d1c1a06dd8b0e4afc5bb91cabc4c91a5a03" => :arm64_big_sur
    sha256 "b1e5bed48c317aed3d64861bea461c7abce9805c325e620bd4eac8295ac0e353" => :catalina
    sha256 "a804e7a7bff4e0bf3fdf274ec1ff0928b80fbcbdedfc4cadc2fdf6ae70aa9f96" => :mojave
    sha256 "68159b9ad518eeb463602115179a194ae365bbfb27a6a947aec801da0ca0d7fe" => :high_sierra
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/ee/25/d3f01bc7e16641e0acb9a8c12decf1d5c2f04336c1f19ba69dc8e6927dff/astroid-2.4.2.tar.gz"
    sha256 "2f4078c2a41bf377eea06d71c9d2ba4eb8f6b1af2135bec27bbbb7d8f12bb703"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/16/2a/79c169c92d95db1ca015c481611b78f5255ef66f8ad8f40276cdcd2e5b68/isort-5.5.4.tar.gz"
    sha256 "ba040c24d20aa302f78f4747df549573ae1eaf8e1084269199154da9c483f07f"
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
    url "https://files.pythonhosted.org/packages/6b/34/415834bfdafca3c5f451532e8a8d9ba89a21c9743a0c59fbd0205c7f9426/six-1.15.0.tar.gz"
    sha256 "30639c035cdb23534cd4aa2dd52c3bf48f06e5f4a941509c8bafd8ce11080259"
  end

  resource "toml" do
    url "https://files.pythonhosted.org/packages/da/24/84d5c108e818ca294efe7c1ce237b42118643ce58a14d2462b3b2e3800d5/toml-0.10.1.tar.gz"
    sha256 "926b612be1e5ce0634a2ca03470f95169cf16f939018233a670519cb4ac58b0f"
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
