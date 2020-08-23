class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://gitlab.com/pycqa/flake8/-/archive/3.8.3/flake8-3.8.3.tar.bz2"
  sha256 "eb8beddb4a94caa8284c8ac4370219f3887c67d1cf9ac722b4a03306fe03e2bc"
  head "https://gitlab.com/PyCQA/flake8.git", shallow: false

  bottle do
    cellar :any_skip_relocation
    sha256 "c69d45f5fc4c8d4626968bb9df56ee0f3bdfe746b61e527f373952ee8225992e" => :catalina
    sha256 "eb9d1de4ade2c8ba850b44bd8a3d8d02c04aa51b021737c61d8498a0d41c404f" => :mojave
    sha256 "d6c5a8a1a2ea74a8d296777d4adb4d916bae7e5ce75852b22690fe3a7c14b894" => :high_sierra
  end

  depends_on "python@3.8"

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
