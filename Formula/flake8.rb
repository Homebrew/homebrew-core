class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/61/b7/de862ffe731e4edae44783f04d153f56bc6081cff1ca5a6680f5e4258f75/flake8-5.0.2.tar.gz"
  sha256 "9cc32bc0c5d16eacc014c7ec6f0e9565fd81df66c2092c3c9df06e3c1ac95e5d"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b1dfb60b5337a24e4867d6f3fa96e541b8e1ddcfbeafd5e6ee6d77f7b0d33d39"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b1dfb60b5337a24e4867d6f3fa96e541b8e1ddcfbeafd5e6ee6d77f7b0d33d39"
    sha256 cellar: :any_skip_relocation, monterey:       "32c2bbf31cc9468efa161ab60cbd010cda5300ce94228c04ebd65f3c5cfc6660"
    sha256 cellar: :any_skip_relocation, big_sur:        "32c2bbf31cc9468efa161ab60cbd010cda5300ce94228c04ebd65f3c5cfc6660"
    sha256 cellar: :any_skip_relocation, catalina:       "32c2bbf31cc9468efa161ab60cbd010cda5300ce94228c04ebd65f3c5cfc6660"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a48df8b12c3fe8e91a177a5a4e654a562e98c59cff9fa0f55fb6f9032c43565b"
  end

  depends_on "python@3.10"

  resource "mccabe" do
    url "https://files.pythonhosted.org/packages/e7/ff/0ffefdcac38932a54d2b5eed4e0ba8a408f215002cd178ad1df0f2806ff8/mccabe-0.7.0.tar.gz"
    sha256 "348e0240c33b60bbdf4e523192ef919f28cb2c3d7d5c7794f74009290f236325"
  end

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/f7/98/95b7936a9439bea0e537a42feca1404e7926518fe054f85d28ad7e4bc6fa/pycodestyle-2.9.0.tar.gz"
    sha256 "beaba44501f89d785be791c9462553f06958a221d166c64e1f107320f839acc2"
  end

  resource "pyflakes" do
    url "https://files.pythonhosted.org/packages/07/92/f0cb5381f752e89a598dd2850941e7f570ac3cb8ea4a344854de486db152/pyflakes-2.5.0.tar.gz"
    sha256 "491feb020dca48ccc562a8c0cbe8df07ee13078df59813b83959cbdada312ea3"
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
