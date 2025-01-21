class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/37/72/e8d66150c4fcace3c0a450466aa3480506ba2cae7b61e100a2613afc3907/flake8-7.1.1.tar.gz"
  sha256 "049d058491e228e03e67b390f311bbf88fce2dbaa8fa673e7aea87b7198b8d38"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1c4c9b36fa6e65d48f7ca029f68c9d15cfe5c5b265a0f9d6ad3dadf099db1b88"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "1c4c9b36fa6e65d48f7ca029f68c9d15cfe5c5b265a0f9d6ad3dadf099db1b88"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "1c4c9b36fa6e65d48f7ca029f68c9d15cfe5c5b265a0f9d6ad3dadf099db1b88"
    sha256 cellar: :any_skip_relocation, sonoma:        "eb44cc7dabc374c174e0bc2088369ccf41038fedecba9135b51e9d27855b6790"
    sha256 cellar: :any_skip_relocation, ventura:       "eb44cc7dabc374c174e0bc2088369ccf41038fedecba9135b51e9d27855b6790"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1c4c9b36fa6e65d48f7ca029f68c9d15cfe5c5b265a0f9d6ad3dadf099db1b88"
  end

  depends_on "python@3.13"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/43/aa/210b2c9aedd8c1cbeea31a50e42050ad56187754b34eb214c46709445801/pycodestyle-2.12.1.tar.gz"
    sha256 "6838eae08bbce4f6accd5d5572075c63626a15ee3e6f842df996bf62f6d73521"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/57/f9/669d8c9c86613c9d568757c7f5824bd3197d7b1c6c27553bc5618a27cce2/pyflakes-3.2.0.tar.gz"
    sha256 "1c61603ff154621fb2a9172037d84dca3500def8c8b630657d1701f026f8af3f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test-bad.py").write <<~PYTHON
      print ("Hello World!")
    PYTHON

    (testpath/"test-good.py").write <<~PYTHON
      print("Hello World!")
    PYTHON

    assert_match "E211", shell_output("#{bin}/flake8 test-bad.py", 1)
    assert_empty shell_output("#{bin}/flake8 test-good.py")
  end
end
