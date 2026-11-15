class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/4a/3b/729d6a29209ff0d16726f3623177c7cfb23f190d3c25bb61e651dd55d371/pyupgrade-3.22.0.tar.gz"
  sha256 "6889a7be7f0d0ea3119789bc50086a008a91ed6c46005a030f8928b501550425"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "a366d5259683277433d658a4e5198dcd5b5c277ef7c0a58879913287a4b68da4"
  end

  depends_on "python@3.15"

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
