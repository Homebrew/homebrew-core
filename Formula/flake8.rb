class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/24/1a/e7d61b77955efe0f5aa413625f3e3c2153768f3e0f234de5d0e91b633200/flake8-4.0.0.tar.gz"
  sha256 "b52d27e627676b015340c3b1c72bc9259a6cacc9341712fb8f01ddfaaa2c651a"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "dc28f983cd59b56dfe54cfc2827e7f68263705cc385a014af8e09c478d75385c"
    sha256 cellar: :any_skip_relocation, big_sur:       "87a52580d472a517fa23a80cc27143c208ab53b2c301f7fdf65fe2ac2a725251"
    sha256 cellar: :any_skip_relocation, catalina:      "87a52580d472a517fa23a80cc27143c208ab53b2c301f7fdf65fe2ac2a725251"
    sha256 cellar: :any_skip_relocation, mojave:        "87a52580d472a517fa23a80cc27143c208ab53b2c301f7fdf65fe2ac2a725251"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9a2aacfe74639153bb6c2d2ab76af234212e06e97fec3e32c9d4dedf462c5127"
  end

  depends_on "python@3.10"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/06/18/fa675aa501e11d6d6ca0ae73a101b2f3571a565e0f7d38e062eec18a91ee/mccabe-0.6.1.tar.gz"
    sha256 "dd8d182285a0fe56bace7f45b5e7d1a6ebcbf524e8f3bd87eb0f125271b8831f"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/08/dc/b29daf0a202b03f57c19e7295b60d1d5e1281c45a6f5f573e41830819918/pycodestyle-2.8.0.tar.gz"
    sha256 "eddd5847ef438ea1c7870ca7eb78a9d47ce0cdb4851a5523949f2601d0cbbe7f"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/15/60/c577e54518086e98470e9088278247f4af1d39cb43bcbd731e2c307acd6a/pyflakes-2.4.0.tar.gz"
    sha256 "05a85c2872edf37a4ed30b0cce2f6093e1d0581f8c19d7393122da7e25b2b24c"
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
