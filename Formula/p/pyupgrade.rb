class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/7f/a1/dc63caaeed232b1c58eae1b7a75f262d64ab8435882f696ffa9b58c0c415/pyupgrade-3.21.2.tar.gz"
  sha256 "1a361bea39deda78d1460f65d9dd548d3a36ff8171d2482298539b9dc11c9c06"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "ca8e4a4fdb95ae8628d558473f7bf140ca5a2ffcd4258a4d8768cfa1bac2951b"
  end

  depends_on "python@3.14"

  resource "tokenize-rt" do
    url "https://files.pythonhosted.org/packages/69/ed/8f07e893132d5051d86a553e749d5c89b2a4776eb3a579b72ed61f8559ca/tokenize_rt-6.2.0.tar.gz"
    sha256 "8439c042b330c553fdbe1758e4a05c0ed460dbbbb24a606f11f0dee75da4cad6"
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
