class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.11/opendetex-2.8.11.tar.bz2"
  sha256 "f5771afc607134f65d502d733552cbc79ef06eee44601ae8077b79d852daa05f"
  license "BSD-3-Clause"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "23938ef4f3e39053df242eace39677f290ec1e1ff000569635443df5fa062a70"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "78f98d7aadb714d796f32b60c3becd898c9ef6a88d14e58fb9c303b8d2ec368e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "55f421f5f7b3500f5ceb9fc05f76b947e012bc2c79b5695ce81b106576cfcba9"
    sha256 cellar: :any_skip_relocation, sonoma:         "5e458e9b340a5784f5b9c776b059a5b2310836918b414ed050d94deefa550612"
    sha256 cellar: :any_skip_relocation, ventura:        "3717e4f330e0abda53e3b27e83f9d46bdf701787433f8d7356cc246ffafc903d"
    sha256 cellar: :any_skip_relocation, monterey:       "ed14c822975353fa8962fdb4c0a3527669cec5df674924145938682f76b38f13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f76bf60e19353d112fdd02b250ea0d87f28688582d0c26f30f580e3cc86434d1"
  end

  uses_from_macos "flex" => :build

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Simple \\emph{text}.
      \\end{document}
    EOS

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end
