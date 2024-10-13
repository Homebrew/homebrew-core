class Pyupgrade < Formula
  include Language::Python::Virtualenv

  desc "Upgrade syntax for newer versions of Python"
  homepage "https://github.com/asottile/pyupgrade"
  url "https://files.pythonhosted.org/packages/8c/71/e826797688b49435e10c41934b919c1b0b7ed1f538001a9b716331afc5a0/pyupgrade-3.18.0.tar.gz"
  sha256 "894cf4c64c17c020f86adaab55a82449a7add29b1ea4a1b9e659ed48c922d3ae"
  license "MIT"
  head "https://github.com/asottile/pyupgrade.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "eb6eb332a5066d4563d2e694722da292f69fbecee34673e4ebdf4fb1ba4edb2f"
  end

  depends_on "python@3.13"

  resource "tokenize-rt" do
    url "https://files.pythonhosted.org/packages/7d/09/6257dabdeab5097d72c5d874f29b33cd667ec411af6667922d84f85b79b5/tokenize_rt-6.0.0.tar.gz"
    sha256 "b9711bdfc51210211137499b5e355d3de5ec88a85d2025c520cbb921b5194367"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.py").write <<~EOS
      print(("foo"))
    EOS

    system bin/"pyupgrade", "--exit-zero-even-if-changed", testpath/"test.py"
    assert_match "print(\"foo\")", (testpath/"test.py").read
  end
end
