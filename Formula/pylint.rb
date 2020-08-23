class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/3b/f0/ee19aeccaea881c38d129f015b2be7658724fcefa3a506d7c44747d764d9/pylint-2.5.3.tar.gz"
  sha256 "7dd78437f2d8d019717dbf287772d0b2dbdfd13fc016aa7faa08d67bccc46adc"
  license "GPL-2.0"

  bottle do
    cellar :any_skip_relocation
    sha256 "0276d309ef75310c6f769fd57bd1c0326c42ad167fada9985d9a18c5219111a8" => :catalina
    sha256 "7382a74b8dc90f0a89a09e525a76967c4872c685d8dae62be7bde0474e750bc3" => :mojave
    sha256 "8ecaf808929ee9c3a7ee76f707b2df886712a7be0c73b7c274f96d4dbd7ba304" => :high_sierra
  end

  depends_on "python@3.8"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/ee/25/d3f01bc7e16641e0acb9a8c12decf1d5c2f04336c1f19ba69dc8e6927dff/astroid-2.4.2.tar.gz"
    sha256 "2f4078c2a41bf377eea06d71c9d2ba4eb8f6b1af2135bec27bbbb7d8f12bb703"
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
