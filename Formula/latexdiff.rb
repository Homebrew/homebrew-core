class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.0/latexdiff-1.3.0.tar.gz"
  sha256 "523d4bb579531286e05d6be5c6a10aaf4cad02bcc1eb70f1cf048be703971ebb"

  bottle do
    cellar :any_skip_relocation
    sha256 "a47814862332c19aebaee585f5b48dfcd70e05d7eb6cf87ff12436928c41029c" => :catalina
    sha256 "6e25d76af6c4385a848dd7e4f59bd8c1c13c257ff2ca53e615abd994cba6c4f7" => :mojave
    sha256 "84bfed3b50311df8d6b11a7a8df65c55c228c3e5cf6d094e65a20596d345ba13" => :high_sierra
    sha256 "84bfed3b50311df8d6b11a7a8df65c55c228c3e5cf6d094e65a20596d345ba13" => :sierra
  end

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
