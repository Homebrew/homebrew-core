class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/71/6a/b3341ef7e7f3585add027d876a7d9837cdfe3320b6c6b5fd0cddfa9ceeac/flake8-3.8.4.tar.gz"
  sha256 "aadae8761ec651813c24be05c6f7b4680857ef6afaae4651a4eccaef97ce6c3b"
  license "MIT"
  revision 1
  head "https://gitlab.com/PyCQA/flake8.git", shallow: false

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    rebuild 1
    sha256 "1897e2a2000df43795e4a1b1de0fecb1e0141e0abce4c0b8df3c6ebad065f8c0" => :big_sur
    sha256 "919c2b7426270504f2cad10d6652336476d3cea402880c5de2653cf2ec21587b" => :arm64_big_sur
    sha256 "136faaf5ecc55423194ac71a9eba7b1b03e694b0f7d4552c7c3d02cc3a7b1377" => :catalina
    sha256 "77329693f9aaf1267a46c1fad72ccb976ccf9995767c256cf89458d36e27f663" => :mojave
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
