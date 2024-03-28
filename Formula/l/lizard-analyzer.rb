class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    rebuild 4
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "02c284fd04edc1e93a337bc460af1935aab5cb867ed4f239dea47e71cd022a4e"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "343ef6e6e8f753d4d063764c0cff1769151999b62bf987ba046aca0ede67090d"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6b4ae7f9bfce19f677e4f93fa2c0ccde987164cce1a197874a6cc692f3eb98d3"
    sha256 cellar: :any_skip_relocation, sonoma:         "3d3586f7af26710b18c0b88b0180af7b86a881c4089d753249bc0420f49f6522"
    sha256 cellar: :any_skip_relocation, ventura:        "916058c731424ddfbc0fa50d1826bc24abe171a944a0b4a32983e9e013e1cc75"
    sha256 cellar: :any_skip_relocation, monterey:       "a5fc576b0cbf6d34a2fe49e795156344106dbc9da9dbe7ff25e27ab2e7f2421d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "78f3014767cf74f7bafcf3c5fc290ce70b8c823e226b9cae6f9537a0520d588f"
  end

  depends_on "python@3.12"

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
