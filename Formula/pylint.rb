class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/87/b6/de7748dac60ff7fa8917f0dc75825ba59f5417053afdafc1d658a6cb4afa/pylint-2.15.4.tar.gz"
  sha256 "5441e9294335d354b7bad57c1044e5bd7cce25c433475d76b440e53452fa5cb8"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9006df163810c09e46df5795eb9cdc95cfa34ae7c718484988f2b2bdf1716550"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b4fd2771e9e40b9819ff2934006e5c7519467144953e4aa6b667c378798b667c"
    sha256 cellar: :any_skip_relocation, monterey:       "5cffec8408a0a8cf82d4bd758c76749d1e0a4a291159b63be1d22f69f071802f"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb7e1f4da7b3988513fb2c630883fd63bb2d3975b9b0a46cdb2037819bea8c3f"
    sha256 cellar: :any_skip_relocation, catalina:       "a92f50a58add8f4372714fe00433ded245039481171ef2908a799a9f6103a284"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fe059499b07804a4fefded4f87f14c7a1251d32800ef2ea73d01a3c4d7e4fb6"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/23/4e/a6f7eda1ef95b05c71a948dbeda1ea8d299301c260fdf7cb317227e3a539/astroid-2.12.11.tar.gz"
    sha256 "2df4f9980c4511474687895cbfdb8558293c1a826d9118bb09233d7c2bff1c83"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/59/46/634d5316ee8984e7dac658fb2e297a19f50a1f4007b09acb9c7c4e15bd67/dill-0.3.5.1.tar.gz"
    sha256 "d75e41f3eff1eee599d738e76ba8f4ad98ea229db8b085318aa2b3333a208c86"
  end

  resource "isort" do
    url "https://files.pythonhosted.org/packages/ab/e9/964cb0b2eedd80c92f5172f1f8ae0443781a9d461c1372a3ce5762489593/isort-5.10.1.tar.gz"
    sha256 "e8443a5e7a020e9d7f97f1d7d9cd17c88bcb3bc7e218bf9cf5095fe550be2951"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/75/93/3fc1cc28f71dd10b87a53b9d809602d7730e84cc4705a062def286232a9c/lazy-object-proxy-1.7.1.tar.gz"
    sha256 "d609c75b986def706743cdebe5e47553f4a5a1da9c5ff66d76013ef396b5a8a4"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "tomli" do
    url "https://files.pythonhosted.org/packages/c0/3f/d7af728f075fb08564c5949a9c95e44352e23dee646869fa104a3b2060a3/tomli-2.0.1.tar.gz"
    sha256 "de526c12914f0c550d15924c62d72abc48d6fe7364aa87328337a31007fe8a4f"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/0c/2b/7823f215c6aec294f5ab5ff2f529aca1d85e8bec2208ae7ea89ca1413620/tomlkit-0.11.5.tar.gz"
    sha256 "571854ebbb5eac89abcb4a2e47d7ea27b89bf29e09c35395da6f03dd4ae23d1c"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
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
