class LizardAnalyzer < Formula
  include Language::Python::Virtualenv

  desc "Extensible Cyclomatic Complexity Analyzer"
  homepage "http://www.lizard.ws"
  url "https://files.pythonhosted.org/packages/60/a7/7a93f5d004bf86209406c533d21d7dede965f976384d29e8681aa47faed9/lizard-1.17.7.tar.gz"
  sha256 "d08e7afb4534fc326401ede2d5aace027757fb1a9deb3cc9f8e7f4339983c630"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "0e16a4352698ce9a033b2670a4031e9bae298631b0bc28012ae8d9f2defedf12" => :catalina
    sha256 "d33983b21c3da6ea5760f48a3528763be0d7222665e84e4163b3a805d5f4465f" => :mojave
    sha256 "e96119714905814a1bcf74f385b40e1742076d615576e55d5533195446733dd8" => :high_sierra
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
