class Pylint < Formula
  include Language::Python::Virtualenv

  desc "It's not just a linter that annoys you!"
  homepage "https://github.com/PyCQA/pylint"
  url "https://files.pythonhosted.org/packages/1a/11/33ca067bf8c21eea413980c8331268ef6c97fe0f345ff4fb251da07dd73c/pylint-2.13.1.tar.gz"
  sha256 "7d5ea593303cf5ca567c60a8d475056825c7373f493ddb16308f09f5fe47f8f4"
  license "GPL-2.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4080e43793f790b9b7b4862f80c6e2a5d624df4bbb320dc2b685713979880a76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a3ac8ea432c01cc465808c6849864a0b15006f2f163fb8cec2fb38624e8fc353"
    sha256 cellar: :any_skip_relocation, monterey:       "da4facf1fa82e5ec9c9137d924a082878a6726b15b61accf57b25dcee42c7e6f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b7857677302af7dee5422c8f3c1e51d9f0b7160a223bc2e4c7c09247bb8845b5"
    sha256 cellar: :any_skip_relocation, catalina:       "e4344ae394292452f896be3c252ba5a898c2b8d48151ac91fe27c13d8a504ef2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c54085ae943bf2870291ba12c5e0f4ba0019b1797715d1343be3b5d288361a08"
  end

  depends_on "python@3.10"

  resource "astroid" do
    url "https://files.pythonhosted.org/packages/32/1d/242aac28594e49755f994e19386ffcb34805e1e0198a72af77cce9a2bfcf/astroid-2.11.1.tar.gz"
    sha256 "33f1c15fe9661348a50b7ec6789947089ead2a5de727bb4782d530d9d2fff2c8"
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
