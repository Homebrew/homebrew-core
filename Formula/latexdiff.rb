class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.1.1/latexdiff-1.3.1.1.tar.gz"
  sha256 "5e55ee205750ccbea8d69cf98791707e7a42ab88e92d3a1101f9de53643aa1d3"
  license "GPL-3.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5fd8db27743a46025e5dbd9ab31181fbdff44648e1b12e850e4c88878e466391"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "90e14ec7fe78b06d74521a9d8ff102589d63935e70f40cfcb7af63d7dbdd0d43"
    sha256 cellar: :any_skip_relocation, monterey:       "d47104ab0a06e597cea157f9a902d5fa2df1123e195bc4778d611cb1916119fe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9ea5219166059a04ab1f510d92339e2443f883a114384d5f8af30b2631ce4921"
    sha256 cellar: :any_skip_relocation, catalina:       "8eb979b1b52125f102bbc56bbc4611d5b8075f003318307a2205485d95c789aa"
    sha256 cellar: :any_skip_relocation, mojave:         "8eb979b1b52125f102bbc56bbc4611d5b8075f003318307a2205485d95c789aa"
    sha256 cellar: :any_skip_relocation, high_sierra:    "8eb979b1b52125f102bbc56bbc4611d5b8075f003318307a2205485d95c789aa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5fd8db27743a46025e5dbd9ab31181fbdff44648e1b12e850e4c88878e466391"
  end

  # osx default perl cause compilation error
  depends_on "perl"

  def install
    bin.install %w[latexdiff-fast latexdiff-so latexdiff-vc latexrevise]
    man1.install %w[latexdiff-vc.1 latexdiff.1 latexrevise.1]
    doc.install Dir["doc/*"]
    pkgshare.install %w[contrib example]

    # Install latexdiff-so (with inlined Algorithm::Diff) as the
    # preferred version, more portable
    bin.install_symlink "latexdiff-so" => "latexdiff"
  end

  test do
    (testpath/"test1.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Hello, world.
      \\end{document}
    EOS

    (testpath/"test2.tex").write <<~EOS
      \\documentclass{article}
      \\begin{document}
      Goodnight, moon.
      \\end{document}
    EOS

    expect = /^\\DIFdelbegin \s+
             \\DIFdel      \{ Hello,[ ]world \}
             \\DIFdelend   \s+
             \\DIFaddbegin \s+
             \\DIFadd      \{ Goodnight,[ ]moon \}
             \\DIFaddend   \s+
             \.$/x
    assert_match expect, shell_output("#{bin}/latexdiff test[12].tex")
  end
end
