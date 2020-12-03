class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.9/opendetex-2.8.9.tar.bz2"
  sha256 "0d6b8cb1f3394b790dd757b0171ad8b398c48e306fa6339e86ed8303c51df084"
  license "BSD-3-Clause"

  bottle do
    cellar :any_skip_relocation
    sha256 "41eed284b3ec304b8957d1d4c5fd36113f1a427f3ff458de513996096e7269bd" => :big_sur
    sha256 "db8c07a7987de189582449f403d15ecbcf7867cac9b1a6694ffe91217fa3f2cb" => :catalina
    sha256 "d9b5550e47478394dd53f9b307bd0398488ac93311a4aa1544f9b7172a0a310c" => :mojave
    sha256 "59bfca18bfe6cf097d158a3e411e0f24f4c800b52d4d43d4f939c8e23082d009" => :high_sierra
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
