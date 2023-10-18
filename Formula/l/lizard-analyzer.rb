class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/70/bbb7c6b5d1b29acca0cd13582a7303fc528e6dbf40d0026861f9aa7f3ff0/lizard-1.17.10.tar.gz"
  sha256 "62d78acd64724be28b5f4aa27a630dfa4b4afbd1596d1f25d5ad1c1a3a075adc"
  license "MIT"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9e4cc18ccee35f9e82fc88d8bbc82b4d171cfca65ea4caa97e5e7b29edba0166"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "37a3837b1add50b1b22d8e8966d011805eb6b04d49af1196a5f78ad2bdcd5f87"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2039beb7f9e476b149918d392670a59899901bd5aae21841a0d4b6a85691006c"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a6c90dcd979f31f80c1fd997c74f9227a28b0767b904630b936ec5a82d5dc24"
    sha256 cellar: :any_skip_relocation, ventura:        "942b1c671d8212f30b34d919624897377df4eb1de4645a9efb10dfbc2471cf76"
    sha256 cellar: :any_skip_relocation, monterey:       "9b8bafa0efb3aface1bdf8ee0953067a10e782cee0929f492d59fe4d37c0314c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "19db78866ca8f07347b05f7c4debdfdbfa1fb112137932feb2401229c2699bb2"
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
