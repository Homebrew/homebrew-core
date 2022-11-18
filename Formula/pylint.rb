class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/4e/9d/fa68dd17140373786c5a379f6b313ceeb324dfe47ff13f717710c2e63c1d/pylint-2.15.5.tar.gz"
  sha256 "3b120505e5af1d06a5ad76b55d8660d44bf0f2fc3c59c2bdd94e39188ee3a4df"
  license "GPL-2.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ce025020d7a16a2efa13d799747f26adbf8fce23e0798aa731f82c0fb99883ce"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "61bb182687a89c1cf6d89077a84443a6e5cf30dcac89afb7195634cec14d6961"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "592e492ef41b9d841d2982a4fc68f5212c905fa87ca4f732765c3eca28d3e2c3"
    sha256 cellar: :any_skip_relocation, ventura:        "f5549dd84661bef719611b25adee87dce30a3e058cf6edeb9cd133a5debefa69"
    sha256 cellar: :any_skip_relocation, monterey:       "92e8920fcf86a917b66763264abde57791d659974d1927c31266d94df7876bcb"
    sha256 cellar: :any_skip_relocation, big_sur:        "aef9aba46d03827a21a45c5ef4ab57541ee5f9ed2ebd2070f53cef907bd8f729"
    sha256 cellar: :any_skip_relocation, catalina:       "909c0c28821630a7018e6d426442f2ea0140d4372608500f3c441602b98c61ea"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "62896f4c1a68c52220a1b6ac5636fe81915e19feb24c91f6c336501ec8fe4455"
  end

  depends_on "isort"
  depends_on "python@3.11"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/be/61/5a97efa0622b3413e3d01d6bc6b019a87bcc23058c378dbd24b8c2474860/astroid-2.12.12.tar.gz"
    sha256 "1c00a14f5a3ed0339d38d2e2e5b74ea2591df5861c0936bb292b84ccf3a78d83"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/7c/e7/364a09134e1062d4d5ff69b853a56cf61c223e0afcc6906b6832bcd51ea8/dill-0.3.6.tar.gz"
    sha256 "e5db55f3687856d8fbdab002ed78544e1c4559a130302693d839dfe8f93f2373"
  end

  resource "lazy-object-proxy" do
    url "https://files.pythonhosted.org/packages/74/37/591f89e8a09ae4574391bdf8a5eecd34a3dbe545917333e625c9de9a66b0/lazy-object-proxy-1.8.0.tar.gz"
    sha256 "c219a00245af0f6fa4e95901ed28044544f50152840c5b6a3e7b2568db34d156"
  end

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "platformdirs" do
    url "https://files.pythonhosted.org/packages/ff/7b/3613df51e6afbf2306fc2465671c03390229b55e3ef3ab9dd3f846a53be6/platformdirs-2.5.2.tar.gz"
    sha256 "58c8abb07dcb441e6ee4b11d8df0ac856038f944ab98b7be6b27b2a3c7feef19"
  end

  resource "tomlkit" do
    url "https://files.pythonhosted.org/packages/ff/04/58b4c11430ed4b7b8f1723a5e4f20929d59361e9b17f0872d69681fd8ffd/tomlkit-0.11.6.tar.gz"
    sha256 "71b952e5721688937fb02cf9d354dbcf0785066149d2855e44531ebdd2b65d73"
  end

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/11/eb/e06e77394d6cf09977d92bff310cb0392930c08a338f99af6066a5a98f92/wrapt-1.14.1.tar.gz"
    sha256 "380a85cf89e0e69b7cfbe2ea9f765f004ff419f34194018a6827ac0e3edfed4d"
  end

  def install
    virtualenv_install_with_resources

    # we depend on isort, but that's a separate formula, so install a `.pth` file to link them
    site_packages = Language::Python.site_packages("python3.11")
    isort = Formula["isort"].opt_libexec
    (libexec/site_packages/"homebrew-isort.pth").write isort/site_packages
  end

  test do
    (testpath/"pylint_test.py").write <<~EOS
      print('Test file'
      )
    EOS
    system bin/"pylint", "--exit-zero", "pylint_test.py"
  end
end
