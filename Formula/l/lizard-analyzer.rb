class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    rebuild 5
    sha256 cellar: :any_skip_relocation, all: "4d2da3335d76532ba20ed3edd74757c5d67e26482ba0925e9f0561dbadb71daf"
  end

  depends_on "python@3.13"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~EOS
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

    assert_match "1 file analyzed.", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
