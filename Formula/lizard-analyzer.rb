class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "39c001d8d352931dd67b8fd4a55fde66128da28134c84d652a7f0a5b59803bb6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "39c001d8d352931dd67b8fd4a55fde66128da28134c84d652a7f0a5b59803bb6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "39c001d8d352931dd67b8fd4a55fde66128da28134c84d652a7f0a5b59803bb6"
    sha256 cellar: :any_skip_relocation, ventura:        "6a4198753f2f0d1ec45e36a3a10c4f93e7d25c08dfc19bdbaeaddec98f16027f"
    sha256 cellar: :any_skip_relocation, monterey:       "6a4198753f2f0d1ec45e36a3a10c4f93e7d25c08dfc19bdbaeaddec98f16027f"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a4198753f2f0d1ec45e36a3a10c4f93e7d25c08dfc19bdbaeaddec98f16027f"
    sha256 cellar: :any_skip_relocation, catalina:       "6a4198753f2f0d1ec45e36a3a10c4f93e7d25c08dfc19bdbaeaddec98f16027f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ade75fa3f82899c4daeb28b9901b582f43465065bb03d2c48719d691f6986211"
  end

  depends_on "python@3.11"

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
    assert_match "1 file analyzed.\n", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
