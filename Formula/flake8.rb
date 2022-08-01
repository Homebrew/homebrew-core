class Flake8 < Formula
  include Language::Python::Virtualenv

  desc "Lint your Python code for style and logical errors"
  homepage "https://flake8.pycqa.org/"
  url "https://files.pythonhosted.org/packages/dd/94/b407f9f904fa387522ed8ba7890bcd1af67b94e2988744159c263e516cf8/flake8-5.0.1.tar.gz"
  sha256 "9c51d3d1426379fd444d3b79eabbeb887849368bd053039066439523d8486961"
  license "MIT"
  head "https://gitlab.com/PyCQA/flake8.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "77ea17bab4218ae4951ae529e7a1460bdbe943486d40a00ac2c7ea5c161378be"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "77ea17bab4218ae4951ae529e7a1460bdbe943486d40a00ac2c7ea5c161378be"
    sha256 cellar: :any_skip_relocation, monterey:       "e22334681a6ab8614f8abb90981d6ab80630e63ab431b6d2324f73157c80d159"
    sha256 cellar: :any_skip_relocation, big_sur:        "e22334681a6ab8614f8abb90981d6ab80630e63ab431b6d2324f73157c80d159"
    sha256 cellar: :any_skip_relocation, catalina:       "e22334681a6ab8614f8abb90981d6ab80630e63ab431b6d2324f73157c80d159"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d4a72487599ac12c4af51df00f123ae8ef852e0c12ae4d164757a412f01ea6d7"
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
