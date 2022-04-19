class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

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
