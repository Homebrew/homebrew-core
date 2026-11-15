class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/9a/da/b0d00f8c4c676212284edd3cc3d371588ce0e36a349373c3a01e188b5639/flake8-7.5.0.tar.gz"
  sha256 "0dab7566341aca0d80aa29b5812bdadf256caa6a63e6068e49ac2649918236a4"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "4dbbca2d65bf66be8ef49406ef3bea25a63b3330013f9444bafd9c41639d872c"
  end

  depends_on "python@3.15"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/86/df/178e41c9ed0ff33c23b3f3757e4e658c889f9abc5ad76ece6cd607b12e9c/pycodestyle-2.15.0.tar.gz"
    sha256 "318f5db083869b4c4dad922d0b11124fb27ab181b6730b93371da671e31bd50e"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/9b/43/f4566b992ab97abd18426aeba516a83c7a833230614a2c3f4d3e9d8ff0f0/pyflakes-4.1.0.tar.gz"
    sha256 "592beb57058eb82eb190fb7514f2081c555c51000b029ff71286a681e6cf2f83"
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
