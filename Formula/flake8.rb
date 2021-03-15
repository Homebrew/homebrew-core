class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/76/ef/63ca8e9026a942af5da9380481c51d9a51326af65d8051fc166ab858bbdb/flake8-3.9.0.tar.gz"
  sha256 "78873e372b12b093da7b5e5ed302e8ad9e988b38b063b61ad937f26ca58fc5f0"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", shallow: false

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "919c2b7426270504f2cad10d6652336476d3cea402880c5de2653cf2ec21587b"
    sha256 cellar: :any_skip_relocation, big_sur:       "1897e2a2000df43795e4a1b1de0fecb1e0141e0abce4c0b8df3c6ebad065f8c0"
    sha256 cellar: :any_skip_relocation, catalina:      "136faaf5ecc55423194ac71a9eba7b1b03e694b0f7d4552c7c3d02cc3a7b1377"
    sha256 cellar: :any_skip_relocation, mojave:        "77329693f9aaf1267a46c1fad72ccb976ccf9995767c256cf89458d36e27f663"
  end

  depends_on "python@3.9"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/02/b3/c832123f2699892c715fcdfebb1a8fdeffa11bb7b2350e46ecdd76b45a20/pycodestyle-2.7.0.tar.gz"
    sha256 "c389c1d06bf7904078ca03399a4816f974a1d590090fecea0c63ec26ebaf1cef"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/52/f2/5642322bb66a424c5d86c1ff3106260debc4f9677313b895358943d40e2f/pyflakes-2.3.0.tar.gz"
    sha256 "e59fd8e750e588358f1b8885e5a4751203a0516e0ee6d34811089ac294c8806f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~EOS
      print ("Hello World!")
    EOS

    (testpath/"test-good.py").write <<~EOS
      print("Hello World!")
    EOS

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
