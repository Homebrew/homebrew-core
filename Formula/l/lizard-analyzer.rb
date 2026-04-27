class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "https://github.com/terryyin/lizard"
  url "https://files.pythonhosted.org/packages/b3/c7/776f75710b0033d69249b45ed571f8a314c1a8980c1d3c64e3c12f541869/lizard-1.22.1.tar.gz"
  sha256 "29fe26f3746f8539227ba909a6143c749548690271e13a3f73204b22e2e62590"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3d7f0e651d81240d53ca95a793da7d9553ae3749ee63c63349108cf1f7bc4ca7"
  end

  depends_on "python@3.14"

  conflicts_with "lizard", because: "both install `lizard` binaries"

  resource "pathspec" do
    url "https://files.pythonhosted.org/packages/2e/17/9c3094b822982b9f1ea666d8580ce59000f61f87c1663556fb72031ad9ec/pathspec-1.1.0.tar.gz"
    sha256 "f5d7c555da02fd8dde3e4a2354b6aba817a89112fa8f333f7917a2a4834dd080"
  end

  resource "pygments" do
    url "https://files.pythonhosted.org/packages/c3/b2/bc9c9196916376152d655522fdcebac55e66de6603a76a02bca1b6414f6c/pygments-2.20.0.tar.gz"
    sha256 "6757cd03768053ff99f3039c1a36d6c0aa0b263438fcab17520b30a303a82b5f"
  end

  def install
    virtualenv_install_with_resources
  end

  test do
    (testpath/"test.swift").write <<~SWIFT
      let base = 2
      let exponent_inner = 3
      let exponent_outer = 4
      var answer = 1

      for _ in 1...exponent_outer {
        for _ in 1...exponent_inner {
          answer *= base
        }
      }
    SWIFT

    assert_match "1 file analyzed.", shell_output("#{bin}/lizard -l swift #{testpath}/test.swift")
  end
end
