class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/c2/94/85870fc02dfe4ab0885c440e7e41f6a986b10e43eca6717e90f8ce1215cc/flake8-7.4.1.tar.gz"
  sha256 "84ea5afcaf344487b0ea5baaebb8100f4cfaebc01f755998f75876664029f587"
  license "MIT"
  head "https://github.com/PyCQA/flake8.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "6f98b0b600995298f16c2861fde614b40b7933e5e4f6fa68885b3b7b37102c17"
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
    url "https://files.pythonhosted.org/packages/2c/1b/3ba8bd62723cfe1b651c4e4b89b33767fce7a08bb800491cf1d3dd3a7716/pyflakes-4.0.3.tar.gz"
    sha256 "94762a3a5a343a79b28754f96c554bce057a592a4896907d73f0369fe824e053"
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
