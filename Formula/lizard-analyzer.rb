class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/bc/c9b66e557203f2a6f5cf3eb704c640e433385dda639c1b2da56b966f9c42/lizard-1.17.4.tar.gz"
  sha256 "ae9485f66e824756a82589e0d9effe58826c3d9f66c9a59b93343d5a8c5ef5a5"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "498bb2088df06bb05ae070e5d7c8ddf0fe866b56b8ecb8eb6706cba52d4a39ac" => :catalina
    sha256 "91af68d9681bddda4bdb7558ed676c1756873e4ac58276b5dfb1a7f9f74b1bef" => :mojave
    sha256 "2571285d55aa0c1653d78594291159f04898d7a0529701fca7f75dacd7e145c3" => :high_sierra
  end

  depends_on "python@3.8"

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
