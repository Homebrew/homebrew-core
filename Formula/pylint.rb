class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/d9/99/2958da59c0203fe40670bcbce52043b4db4e74ef0db14ab59d5b66c0ba6c/pylint-2.14.3.tar.gz"
  sha256 "4e1378f815c63e7e44590d0d339ed6435f5281d0a0cc357d29a86ea0365ef868"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5df1ec4bdbcc895d71d58cff25f2ede6f42a3d82402425511b7f121c19e7b47c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "02c3b888ec27e6cbbead67ca7bbfa7f5c7029efd9ac269b5aa237c9c5645e11c"
    sha256 cellar: :any_skip_relocation, monterey:       "99e3b09060f57044689b6564000c8a802ac1259d8093789a8538f3c2d8fd4f34"
    sha256 cellar: :any_skip_relocation, big_sur:        "7bd9aa070b1ea71251a197836f47470971c239b3bc8ef0ba4fde099f86bc9906"
    sha256 cellar: :any_skip_relocation, catalina:       "063d3df1dc4b39bbc67e3480b141146af5a61cd0691ab34f23b0d55ef3c550ac"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e628840917fbc69cccd2b51e962d3cc13f36ddfafa219bb8542bbf31c46414e1"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/40/89/d29f51ca63b25c488e8f12812d80a970d1f0897de22b175d8ff23f2dcbe7/astroid-2.11.6.tar.gz"
    sha256 "4f933d0bf5e408b03a6feb5d23793740c27e07340605f236496cd6ce552043d6"
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
    url "https://files.pythonhosted.org/packages/24/24/e50be8344fc6e9c9ae55bfcb136b33ad562776d822736da3d1ec0278b18b/tomlkit-0.11.0.tar.gz"
    sha256 "71ceb10c0eefd8b8f11fe34e8a51ad07812cb1dc3de23247425fbc9ddc47b9dd"
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
