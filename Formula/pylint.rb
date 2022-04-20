class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/93/00/400ae57f6e78cf786d8f9a9b3ec9a18547fba5cf690eeb37bffffcd9e40c/pylint-2.13.6.tar.gz"
  sha256 "8b1265173abaf37c2e7a21989d05fd6b0f8032c6772f85abe3b0652903aac66c"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c189dfce5381f43ac400b070fc3d9a3045d16ad6980dee3d0100bbe000f6fa84"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1434ccdbc07199081e37e09e96be8f6097212241e188157af4138ffc52c33397"
    sha256 cellar: :any_skip_relocation, monterey:       "c5b082f04669fdf05d3584b977b5140daf72b154b25375a658df8291b552fd7f"
    sha256 cellar: :any_skip_relocation, big_sur:        "693c5eec9f528d329b5c8ef0a2731aad3d9c9a6ca3870ae693c4b5db66b78540"
    sha256 cellar: :any_skip_relocation, catalina:       "710d9ca36083d449f22ae57e3653f4e426fe09c1c356f21ed5e4a98848e23ad6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "927f9350ff4c0c777eed1bf607167e808f110699ccb471f9b26fc0233b5f8776"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/98/c8/e1de5f7dd1ff87c2dd9fce3e7e0dd5605946cdc480bdf70cf95d5bbbfd45/astroid-2.11.3.tar.gz"
    sha256 "4e5ba10571e197785e312966ea5efb2f5783176d4c1a73fa922d474ae2be59f7"
  end

  resource "dill" do
    url "https://files.pythonhosted.org/packages/57/b7/c4aa04a27040e6a3b09f5a652976ead00b66504c014425a7aad887aa8d7f/dill-0.3.4.zip"
    sha256 "9f9734205146b2b353ab3fec9af0070237b6ddae78452af83d2fca84d739e675"
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

  resource "wrapt" do
    url "https://files.pythonhosted.org/packages/c7/b4/3a937c7f8ee4751b38274c8542e02f42ebf3e080f1344c4a2aff6416630e/wrapt-1.14.0.tar.gz"
    sha256 "8323a43bd9c91f62bb7d4be74cc9ff10090e7ef820e27bfe8815c57e68261311"
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
