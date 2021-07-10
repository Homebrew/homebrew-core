class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/45/16/dbe57aa29fa48eb76ae0b4d25a041cf6e2e2323afda72497429c31a18211/lizard-1.17.9.tar.gz"
  sha256 "76ee0e631d985bea1dd6521a03c6c2fa9dce5a2248b3d26c49890e9e085b7aed"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f448055736149c8292402df3e40cef3e45a6799dba306607a503a42992ca3f4"
    sha256 cellar: :any_skip_relocation, big_sur:       "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
    sha256 cellar: :any_skip_relocation, catalina:      "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
    sha256 cellar: :any_skip_relocation, mojave:        "d63deffcff2ad35e8ddf2ad9c47e6c0ee7817e215ba9ad23639a46b6ab25b678"
  end

  depends_on "python@3.9"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~'EOS'
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    EOS
    assert_match "1 file analyzed.\n", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
