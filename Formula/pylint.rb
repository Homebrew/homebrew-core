class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/18/a7/2bf9363ec428818abd27a64ec44c84b13bf1c10df01c402f08391aa1d07c/pylint-2.8.3.tar.gz"
  sha256 "0a049c5d47b629d9070c3932d13bff482b12119b6a241a93bc460b0be16953c8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "363a069bc90ee2b8c7c364a02b02c81317e170e7fd8618afd7f2ad76ac5ebd30"
    sha256 cellar: :any_skip_relocation, big_sur:       "c3d754cdc9bea9565d34ce84a5171e0f69f0fa40cfadbd03277546d3e0216a74"
    sha256 cellar: :any_skip_relocation, catalina:      "e9f31b3befa76939cb86e989e53696704a49ac6632b0775cc6654aa7c08ebede"
    sha256 cellar: :any_skip_relocation, mojave:        "bfb98defdc490f7dd7c73ac229e32e5af8f00cd3133757e50b35301b83cfdfae"
  end

  depends_on "python@3.9"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/bc/72/51d6389690b30adf1ad69993923f81b71b2110b16e02fd0afd378e30c43c/astroid-2.5.6.tar.gz"
    sha256 "8a398dfce302c13f14bab13e2b14fe385d32b73f4e4853b9bdfb64598baa1975"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/31/8a/6f5449a7be67e4655069490f05fa3e190f5f5864e6ddee140f60fe5526dd/isort-5.8.0.tar.gz"
    sha256 "0a943902919f65c5684ac4e0154b1ad4fac6dcaa5d9f3426b732f1c8b5419be6"
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
