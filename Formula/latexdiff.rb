class Latexdiff < Formula
  desc "Compare and mark up LaTeX file differences"
  homepage "https://www.ctan.org/pkg/latexdiff"
  url "https://github.com/ftilmann/latexdiff/releases/download/1.3.3/latexdiff-1.3.3.tar.gz"
  sha256 "79619ad9ac53b81e9f37e0dd310bb7e4c2497506f1ffe483582f6c564572cb36"
  license "GPL-3.0-or-later"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6cb7541c9dcddb8fa58cff401cea3313d9602f1829f77d16a8bab42e9909253c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6cb7541c9dcddb8fa58cff401cea3313d9602f1829f77d16a8bab42e9909253c"
    sha256 cellar: :any_skip_relocation, monterey:       "c79073ff78df1073956006d14de25a9f7c88d11ce434508f75ca0a6816d2ec74"
    sha256 cellar: :any_skip_relocation, big_sur:        "c79073ff78df1073956006d14de25a9f7c88d11ce434508f75ca0a6816d2ec74"
    sha256 cellar: :any_skip_relocation, catalina:       "c79073ff78df1073956006d14de25a9f7c88d11ce434508f75ca0a6816d2ec74"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6cb7541c9dcddb8fa58cff401cea3313d9602f1829f77d16a8bab42e9909253c"
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
