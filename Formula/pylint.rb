class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/a0/a9/6538482ccd86ef43326b7aa2c806256ab8281f9bd969f58acc526af1a986/pylint-2.15.2.tar.gz"
  sha256 "f63404a2547edb5247da263748771ac9a806ed1de4174cda01293c08ddbc2999"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "47800656d749bb7b9ee002fcf3d99996d499a2182731c247253cf130f8128e48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c5a5f5150650075ac5d17fe47e29b6a6194119ec5b18f8526fdd293c54c27288"
    sha256 cellar: :any_skip_relocation, monterey:       "577ac207dd98388e172f11826940f39f000f8048fdfcc503f0e336b19d9eb50b"
    sha256 cellar: :any_skip_relocation, big_sur:        "b65978491f9b86411811a7609e207a88510fde3db257051c8c79822df7ee866f"
    sha256 cellar: :any_skip_relocation, catalina:       "e9b7d7cff378fc4e4db7277603e17f1698fb9f916eb99106dd52d507ba97f19d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "038dc8ae764daa389c20a7ec4d5112844907367b204e66d7a32a942acb9483d7"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/d4/a8/0b849573a58ba1d2f96e8a91e2ece9daced5fadcfc990d2d473b86814be3/astroid-2.12.9.tar.gz"
    sha256 "0dafbfcf4ebdecd3c8f6d742c9d9c88508229ca823d5c98ab872d964f3321e56"
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
