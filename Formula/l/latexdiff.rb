class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.4/latexdiff-1.3.4.tar.gz"
  sha256 "aed1c39d51e5c7a8894a5e4b7190106e93968dd90edcc0dde803fcbffe01b2b4"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "2733f594fcc18b912a6ed5085f365f2c18e441986ef76941df61692ae6104280"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "fd4029165843d24c4a920c3d66a9ae972b5b7be28b4a304d742d718e513be702"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "fd4029165843d24c4a920c3d66a9ae972b5b7be28b4a304d742d718e513be702"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fd4029165843d24c4a920c3d66a9ae972b5b7be28b4a304d742d718e513be702"
    sha256 cellar: :any_skip_relocation, sonoma:         "a25ecc5e1e606ed064a253fe450afef53dd94d9a43a8c5113f8ee2e226af1a47"
    sha256 cellar: :any_skip_relocation, ventura:        "a25ecc5e1e606ed064a253fe450afef53dd94d9a43a8c5113f8ee2e226af1a47"
    sha256 cellar: :any_skip_relocation, monterey:       "a25ecc5e1e606ed064a253fe450afef53dd94d9a43a8c5113f8ee2e226af1a47"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e878eba7d85094fc7b5622f3d7eef4e9ff0d9dc1c97e4babc0f474ac26520485"
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
