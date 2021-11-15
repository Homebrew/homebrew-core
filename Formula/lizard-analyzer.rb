class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/45/16/dbe57aa29fa48eb76ae0b4d25a041cf6e2e2323afda72497429c31a18211/lizard-1.17.9.tar.gz"
  sha256 "76ee0e631d985bea1dd6521a03c6c2fa9dce5a2248b3d26c49890e9e085b7aed"
  license "MIT"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8519ce83f386caab0ffda28fa138646b490c914eca8a03ffd32af55f461f5acc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8519ce83f386caab0ffda28fa138646b490c914eca8a03ffd32af55f461f5acc"
    sha256 cellar: :any_skip_relocation, monterey:       "46dbc9104c475ec2fc78e92e18c7198b30b76b10a670c586b060d02de5a334f5"
    sha256 cellar: :any_skip_relocation, big_sur:        "46dbc9104c475ec2fc78e92e18c7198b30b76b10a670c586b060d02de5a334f5"
    sha256 cellar: :any_skip_relocation, catalina:       "46dbc9104c475ec2fc78e92e18c7198b30b76b10a670c586b060d02de5a334f5"
    sha256 cellar: :any_skip_relocation, mojave:         "46dbc9104c475ec2fc78e92e18c7198b30b76b10a670c586b060d02de5a334f5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f04c3501b9bf82469b4581a9ad11b9d6f1995e72e0034486fe6918251977299"
  end

  depends_on "python@3.10"

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
