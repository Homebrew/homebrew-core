class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/82/e5/ae649803c4f3a4e47720337352af046089f8e9ff8a25958199df74268984/pylint-2.14.5.tar.gz"
  sha256 "487ce2192eee48211269a0e976421f334cf94de1806ca9d0a99449adcdf0285e"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "759f246d44be0c4361394cefda2ed9411b5847d47187f757f20de8cddd700f72"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "37bd394a4cf5d5432a6412f15f6180f5ef2362ba53506ef69f077d24f22eda02"
    sha256 cellar: :any_skip_relocation, monterey:       "59189122fe5194fcbc8c5ba73f70228339e727a479b8b771f9dd6e2f26f965fa"
    sha256 cellar: :any_skip_relocation, big_sur:        "2646b8cde99cf71af443564edb6fd22b73ef21a3a4bb1c3780e75fbc9d22af1d"
    sha256 cellar: :any_skip_relocation, catalina:       "47ce288d03e8dab7ab9e8dd153c713239ee73c4abd6e11da220c6d85fe199290"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0442e2170b41c7b280700f17d035d0405185ece4af37b564582353cc315f19ef"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/47/fa/cedd4cf37634b2fcc3773cedd0a9ca05fed2fa014d3d03815b04b7738ade/astroid-2.11.7.tar.gz"
    sha256 "bb24615c77f4837c707669d16907331374ae8a964650a66999da3f5ca68dc946"
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
    url "https://files.pythonhosted.org/packages/1e/81/93889ea6641154b22f26036bc4ef800b06df84fc647a6ded5abdc2f06dcf/tomlkit-0.11.1.tar.gz"
    sha256 "61901f81ff4017951119cd0d1ed9b7af31c821d6845c8c477587bbdcd5e5854e"
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
