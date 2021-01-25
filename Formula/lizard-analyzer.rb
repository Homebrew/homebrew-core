class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/60/a7/7a93f5d004bf86209406c533d21d7dede965f976384d29e8681aa47faed9/lizard-1.17.7.tar.gz"
  sha256 "d08e7afb4534fc326401ede2d5aace027757fb1a9deb3cc9f8e7f4339983c630"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7c38c8e8ed4b8cb71d2021b6d4eb0aae2d8bae8976634f93242943ce91bf1bbe" => :big_sur
    sha256 "6261f2b69242bb01b65933bd32cbe97a510465b9648294c3065ac2c3c49c2059" => :arm64_big_sur
    sha256 "f3e7d8d0c1108714727d7b8065166073f207a5d35ad302f1be788d48c91cca51" => :catalina
    sha256 "bc9bca50b8f2d83404353f5692021d00e995ca95dc389eb976584ae29d1bb1f9" => :mojave
    sha256 "79f9a6da530de4e7d15a93256a7eb7ec4bcf4b4a227c601974cccdeee21b9a32" => :high_sierra
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
