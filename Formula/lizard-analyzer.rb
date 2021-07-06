class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/3d/ff/eb45fbc169f9aac6d9798933ad1b624e5d01c2191efc0134d8014e20b4a2/lizard-1.17.8.tar.gz"
  sha256 "da8f62b478b9b2fffcddba274259b79bacce7509ccc14e1074cb54516d5ade15"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6261f2b69242bb01b65933bd32cbe97a510465b9648294c3065ac2c3c49c2059"
    sha256 cellar: :any_skip_relocation, big_sur:       "7c38c8e8ed4b8cb71d2021b6d4eb0aae2d8bae8976634f93242943ce91bf1bbe"
    sha256 cellar: :any_skip_relocation, catalina:      "f3e7d8d0c1108714727d7b8065166073f207a5d35ad302f1be788d48c91cca51"
    sha256 cellar: :any_skip_relocation, mojave:        "bc9bca50b8f2d83404353f5692021d00e995ca95dc389eb976584ae29d1bb1f9"
    sha256 cellar: :any_skip_relocation, high_sierra:   "79f9a6da530de4e7d15a93256a7eb7ec4bcf4b4a227c601974cccdeee21b9a32"
  end

  depends_on "python@3.9"

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
