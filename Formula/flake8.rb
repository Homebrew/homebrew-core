class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/-/archive/3.8.4/flake8-3.8.4.tar.bz2"
  sha256 "66f65cf5614a24f813a76ab6388507ad8def068dcee859568a3c32a49a5d597b"
  license "MIT"
  revision 1
  head "https://gitlab.com/PyCQA/flake8.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "aa8db7e7d150ff72c2b0ee62a431815ff978dd004b6bc0bb20ff6f58175bdb72" => :catalina
    sha256 "38c8b24e9e93e18056478da43452621521e9edbc18d65d80c446044bfd672add" => :mojave
    sha256 "54672186e5aa4e630c877d95ca562312eacbe1bc0edbe2a9e92f05ae5e5c93e0" => :high_sierra
  end

  depends_on "python@3.9"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/bb/82/0df047a5347d607be504ad5faa255caa7919562962b934f9372b157e8a70/pycodestyle-2.6.0.tar.gz"
    sha256 "c58a7d2815e0e8d7972bf1803331fb0152f867bd89adf8a01dfd55085434192e"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/f1/e2/e02fc89959619590eec0c35f366902535ade2728479fc3082c8af8840013/pyflakes-2.2.0.tar.gz"
    sha256 "35b2d75ee967ea93b55750aa9edbbf72813e06a66ba54438df2cfac9e3c27fc8"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      print("Hello World!")
    EOS

    system "#{bin}/flake8", "test.py"
  end
end
