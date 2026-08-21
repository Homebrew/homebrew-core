class Autopep8 < Formula
  include Language::Python::Virtualenv

  desc "Automatically formats Python code to conform to the PEP 8 style guide"
  homepage "https://github.com/hhatto/autopep8"
  url "https://files.pythonhosted.org/packages/50/d8/30873d2b7b57dee9263e53d142da044c4600a46f2d28374b3e38b023df16/autopep8-2.3.2.tar.gz"
  sha256 "89440a4f969197b69a995e4ce0661b031f455a9f776d2c5ba3dbd83466931758"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "5f1bd9503359c8e67f6cefd931a53b5749aea1415fcfb1ed26ed3cda9b761702"
  end

  depends_on "python@3.14"

  resource "pycodestyle" do
    url "https://files.pythonhosted.org/packages/11/e0/abfd2a0d2efe47670df87f3e3a0e2edda42f055053c85361f19c0e2c1ca8/pycodestyle-2.14.0.tar.gz"
    sha256 "c4b5b517d278089ff9d0abdec919cd97262a3367449ea1c8b49b91529167b783"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    output = pipe_output("#{bin}/autopep8 -", "x='homebrew'", 0)
    assert_equal "x = 'homebrew'", output.strip
  end
end
