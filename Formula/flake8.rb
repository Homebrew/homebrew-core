class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/e6/84/d8db922289195c435779b4ca3a3f583f263f87e67954f7b2e83c8da21f48/flake8-4.0.1.tar.gz"
  sha256 "806e034dda44114815e23c16ef92f95c91e4c71100ff52813adf7132a6ad870d"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8825fc651aedaca0d41bef074d050ccd276b1c575e74c1626bc63b9307aaddc7"
    sha256 cellar: :any_skip_relocation, big_sur:       "b1a2e83f304a6fd0a9e2f53a1239e3a41b37ce5c2bbdce901a371a35279eb0fd"
    sha256 cellar: :any_skip_relocation, catalina:      "b1a2e83f304a6fd0a9e2f53a1239e3a41b37ce5c2bbdce901a371a35279eb0fd"
    sha256 cellar: :any_skip_relocation, mojave:        "b1a2e83f304a6fd0a9e2f53a1239e3a41b37ce5c2bbdce901a371a35279eb0fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cda80a0abf0a9f5e121f941262273be2afada7628f8580f771832dfbe702f344"
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
