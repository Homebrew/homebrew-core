class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.3/latexdiff-1.3.3.tar.gz"
  sha256 "79619ad9ac53b81e9f37e0dd310bb7e4c2497506f1ffe483582f6c564572cb36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f8d86124c7257174e320c6fb0c26eb54254079ce7af27cdc303cdf8d88a8bac9"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8d86124c7257174e320c6fb0c26eb54254079ce7af27cdc303cdf8d88a8bac9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8d86124c7257174e320c6fb0c26eb54254079ce7af27cdc303cdf8d88a8bac9"
    sha256 cellar: :any_skip_relocation, ventura:        "1d9555dcabb14322349dd93128d81078dfc4326878532173f184c8f9dbb61757"
    sha256 cellar: :any_skip_relocation, monterey:       "1d9555dcabb14322349dd93128d81078dfc4326878532173f184c8f9dbb61757"
    sha256 cellar: :any_skip_relocation, big_sur:        "1d9555dcabb14322349dd93128d81078dfc4326878532173f184c8f9dbb61757"
    sha256 cellar: :any_skip_relocation, catalina:       "1d9555dcabb14322349dd93128d81078dfc4326878532173f184c8f9dbb61757"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8d86124c7257174e320c6fb0c26eb54254079ce7af27cdc303cdf8d88a8bac9"
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
