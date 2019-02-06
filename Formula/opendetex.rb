class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.5/opendetex-2.8.5.tar.bz2"
  sha256 "90be111ec1f47af25317d1dbe2f07a350cc46e1bc4cdc995dde79219d7c2623d"

  bottle do
    cellar :any_skip_relocation
    sha256 "995070391cee23f402d6e067985230d467e48b5a20b5122e05474bec73cfeb24" => :mojave
    sha256 "c668bd3fd940b6f27ce4162b5625ff28e45df24e34f7f66b6a2158546a47e6d9" => :high_sierra
    sha256 "4ce5d750a06de0c96682042e88aea55707e5c0b28cbea66396ec1020df130420" => :sierra
    sha256 "79e56e9e50f90d6b534f29c556a648743ee10ab494d5f7cd049031eb4833f122" => :el_capitan
  end

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
