class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    rebuild 3
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a6e75f6be81d02683b3e843d2f460ee2fbba1fd5438526aaf3e35774dd619881"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d9f19bae3e6c6eb314187155e8290eddf4f4ea2b7e9e0d741aeb9a685ac9186"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "619457a0446857df8e23958d3312d8f997a6149addb6aee027001ebcce37360f"
    sha256 cellar: :any_skip_relocation, sonoma:         "ce8d0c46a6b2ea3bf507798ab1885002585d8274cc5da77175613aca37dbf099"
    sha256 cellar: :any_skip_relocation, ventura:        "054ae8e53fd2a0145ad6be71cd8eb8eceb734a3ef701714f638fd2f65b713d3f"
    sha256 cellar: :any_skip_relocation, monterey:       "342da2deb16b395043ec2cdd302b83d482eb3c9ca45f3ef45dfd6e699e2cf848"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0f46c945d71e652f59d6cb4a902f17df6d0b2a658429b9f0caf8f630b4ef544e"
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
