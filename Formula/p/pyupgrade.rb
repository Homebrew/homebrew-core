class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/c0/75/3df66861bca41394f05c5b818943fd0535bc02d5c5c512f9d859dec921f3/pyupgrade-3.20.0.tar.gz"
  sha256 "dd6a16c13fc1a7db45796008689a9a35420bd364d681430f640c5e54a3d351ea"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ac89a57ce2088190a42be7240a41060d18fcf8d4b63e9c06ce9758c1ce496668"
  end

  depends_on "python@3.13"

  resource "tokenize-rt" do
    url "https://files.pythonhosted.org/packages/6b/0a/5854d8ced8c1e00193d1353d13db82d7f813f99bd5dcb776ce3e2a4c0d19/tokenize_rt-6.1.0.tar.gz"
    sha256 "e8ee836616c0877ab7c7b54776d2fefcc3bde714449a206762425ae114b53c86"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~PYTHON
      print(("foo"))
    PYTHON

    system bin/"pyupgrade", "--exit-zero-even-if-changed", testpath/"test.py"
    assert_match "print(\"foo\")", (testpath/"test.py").read
  end
end
