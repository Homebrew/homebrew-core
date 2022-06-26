class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c83c2c3fdb726b91840d2855bb1610d0a6ae28a13dcafdb5de8c919989550361"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c83c2c3fdb726b91840d2855bb1610d0a6ae28a13dcafdb5de8c919989550361"
    sha256 cellar: :any_skip_relocation, monterey:       "84f2bb45b64ad581b192bece7e059973e44b6b18ea850558091a1c4b44e75181"
    sha256 cellar: :any_skip_relocation, big_sur:        "84f2bb45b64ad581b192bece7e059973e44b6b18ea850558091a1c4b44e75181"
    sha256 cellar: :any_skip_relocation, catalina:       "84f2bb45b64ad581b192bece7e059973e44b6b18ea850558091a1c4b44e75181"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9f41ad1d419b165bb654888c8048deacb609b1db3eadf0470e89fb9728ddcf99"
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
