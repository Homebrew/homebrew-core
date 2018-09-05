class Latexdiff < Formula
  desc "Determine and markup differences between two LaTeX files"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.2.1/latexdiff-1.2.1.tar.gz"
  sha256 "12634c8ec5c68b173d3906679bb09330e724491c6a64e675989217cf4790604e"

  bottle do
    cellar :any_skip_relocation
    sha256 "ddcf64d90ce3117e7b5ae80fe87968ac37e573c2d5baaa70d9824a5003f6c887" => :mojave
    sha256 "defcfd366232b19b67f087f085113a30d18f9e42f70ee2b44eb03828ef1f0727" => :high_sierra
    sha256 "defcfd366232b19b67f087f085113a30d18f9e42f70ee2b44eb03828ef1f0727" => :sierra
    sha256 "defcfd366232b19b67f087f085113a30d18f9e42f70ee2b44eb03828ef1f0727" => :el_capitan
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
