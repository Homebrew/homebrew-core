class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/a2/5e/16fc88b580609b52142b4f56f5bb64ea12f74239f65eb4aa2c47e034d20a/pylint-2.9.1.tar.gz"
  sha256 "d8f9e6ff7bc2e64a724b1b4409f0a30014891fc006ffbf68b590015e364322ec"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "a98edc9f190bc278b4404633878d05d8586b916a7045fce852ba78b86c41557a"
    sha256 cellar: :any_skip_relocation, big_sur:       "a600c746555bdc0f9e8b46d06ff8e5fc8664af994fa90091e0062eac47a5585c"
    sha256 cellar: :any_skip_relocation, catalina:      "3c3021418cc4fd8533ddc474b70c8d1ceb9525253ed88727ff4279405893be86"
    sha256 cellar: :any_skip_relocation, mojave:        "3cd25b40ace12aa27cbce1bc6e7539e2427a08fb1d7b1813456165eefeeda88d"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/6a/7f/90312f42efc2a5249f26e436be10f0c53c512b2f3a36af364cd021283660/astroid-2.6.2.tar.gz"
    sha256 "38b95085e9d92e2ca06cf8b35c12a74fa81da395a6f9e65803742e6509c05892"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/b7/8b/7c2200599c22b4ef6f3688f93c4f44065926bc05cbd38c31247b1348f9a3/isort-5.9.1.tar.gz"
    sha256 "83510593e07e433b77bd5bff0f6f607dbafa06d1a89022616f02d8b699cfcd56"
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
