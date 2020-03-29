class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.5/opendetex-2.8.5.tar.bz2"
  sha256 "90be111ec1f47af25317d1dbe2f07a350cc46e1bc4cdc995dde79219d7c2623d"

  bottle do
    cellar :any_skip_relocation
    sha256 "a4c30579f779f826b0d4a8566137f8508b5455260f87b098526ada644099286e" => :catalina
    sha256 "1d1398816b57a57132dc12b27cd35c44dd15568a5d46ada1dedc808a603bdcca" => :mojave
    sha256 "41c7aa616e4770b69db95fe490a23ebbc1009b44bbe265a426059326534b06c1" => :high_sierra
    sha256 "ed5ae661b1244d2d3b6c300176ba9cf797c50df7ae7e116cd077b1e1ff3f2bc3" => :sierra
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
