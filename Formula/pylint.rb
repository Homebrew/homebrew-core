class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/76/4e/e0420c7283541d984aa03d48b8758d514ac002a1d08a56e48f16302d6a98/pylint-2.15.0.tar.gz"
  sha256 "4f3f7e869646b0bd63b3dfb79f3c0f28fc3d2d923ea220d52620fd625aed92b0"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "abc9abdb3cffbfbf65789ecf3a241c168ce9292313a577c5f5d91c81c28e252f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7537fca85a1e757da6d35611ba938a97c7818263ade2b6ab5728b0873e2aad37"
    sha256 cellar: :any_skip_relocation, monterey:       "8d1f2332385a86ac0ab5d692ddd139b21b7d93a36b460fbc104702a678c82517"
    sha256 cellar: :any_skip_relocation, big_sur:        "8ce688854d61dcca2b2cee007a6d82cb1655d25cab7b37b80454f6389d41c120"
    sha256 cellar: :any_skip_relocation, catalina:       "0e9b08a422214f2df4c6d7e4b796d131a47c6a5ea60da9c9d16f16e5f2781779"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "38ec9d00a2c6a777216a0e832c67a99833faed6ec4cf8fc0ab4e3d0e5ce8594d"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/f0/53/abbf8ce4f5cff1763aec6f5d7b8e0b2284f2ce9401b660fd4187bcb1ff57/astroid-2.12.4.tar.gz"
    sha256 "39fa822c82dc112f5072a208ddf01c58184043aa90e3e469786fa0520c71aaa7"
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
    url "https://files.pythonhosted.org/packages/84/51/092a8b945edc3b93f2de091ab9596006673caac063e3fac14f0fa6c69b1c/tomlkit-0.11.4.tar.gz"
    sha256 "3235a9010fae54323e727c3ac06fb720752fe6635b3426e379daec60fbd44a83"
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
