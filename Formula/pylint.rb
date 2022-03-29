class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/17/20/4261712608bce9aba2e502631162920fb60b0da5fbfb1b2f0560314c05ab/pylint-2.13.3.tar.gz"
  sha256 "12ed2520510c40db647e4ec7f747b07e0d669b33ab41479c2a07bb89b92877db"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff1f54c61653b550e09834cbf3e1239b089a452fa5521fd4f2af832086973c8d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a950e25ad9326eb203ce0314699dc735ff424c2908632f1ad81bdd108d88b1"
    sha256 cellar: :any_skip_relocation, monterey:       "ea50c35f6b61ae22384f82f4f32dfc21311385a6efd0827039913e26cf8e9a7b"
    sha256 cellar: :any_skip_relocation, big_sur:        "af56021f4c5907f210faf5465dc8a7e16a2a35dc9e5a7d2f1979e2c3c4aa56b9"
    sha256 cellar: :any_skip_relocation, catalina:       "c3dca34c09380303c91a59ab03bb9e99acf230c4989c4f62ae07c8c559b9e32c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a8bcccad34ad1fb29311172242108b991d83826098090af132203542b4ea1a50"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/0b/93/98b506fe286a486a66694a39014bea6537e765fce70bb0ffc297c5806e2a/astroid-2.11.2.tar.gz"
    sha256 "8d0a30fe6481ce919f56690076eafbb2fb649142a89dc874f1ec0e7a011492d0"
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
    url "https://files.pythonhosted.org/packages/33/66/61da40aa546141b0d70b37fe6bb4ef1200b4b4cb98849f131b58faa9a5d2/platformdirs-2.5.1.tar.gz"
    sha256 "7535e70dfa32e84d4b34996ea99c5e432fa29a708d0f4e394bbcb2a8faa4f16d"
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
