class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/ef/bc/c9b66e557203f2a6f5cf3eb704c640e433385dda639c1b2da56b966f9c42/lizard-1.17.4.tar.gz"
  sha256 "ae9485f66e824756a82589e0d9effe58826c3d9f66c9a59b93343d5a8c5ef5a5"

  bottle do
    cellar :any_skip_relocation
    sha256 "80d41ae6d7116eabd0c66c9f23727724d33bb8fca72eec77aff0a6a7f937ce93" => :catalina
    sha256 "fa707773514478d7b4fd31c41671b4fff34254f039f6df3760aeb1b77ebb455c" => :mojave
    sha256 "7c0e57fd3a311b21eddad247a58195c0b518d0291a5a651fb066d4f48a5129a9" => :high_sierra
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
