class Opendetex < Formula
  desc "Tool to strip TeX or LaTeX commands from documents"
  homepage "https://github.com/pkubowicz/opendetex"
  url "https://github.com/pkubowicz/opendetex/releases/download/v2.8.12/opendetex-2.8.12.tar.bz2"
  sha256 "d1fcffe7290c6fff2db77e9074b896979b8ce72b3c2fc47de3341bb6652da02a"
  license "NCSA"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "bfa66a9b4172b77de3ee11c3af36945f1fb8a3dd5f8b8bd6c2f27aa128ddcd60"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "fe24ff34b790124f1528f9e4e31250e9cb3800625fe64ca656b99cda5be12658"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "3f3322e3a1707997a3e4da82976c226a5bc261c30c7f7e234cc1c1e491b105fd"
    sha256 cellar: :any,                 arm64_linux:       "9d2a3a893e2318a9c82a1bac93c5b242b425bab8007ee6bdefeb7b6604a1fed2"
    sha256 cellar: :any,                 x86_64_linux:      "6564b39dc39006e921c2f825e183477f519d36abc13d017ac1b6a8626bae4d3e"
  end

  uses_from_macos "flex" => :build

  conflicts_with "texlive", because: "both install `detex` binaries"

  deny_network_access!

  def install
    system "make"
    bin.install "detex"
    bin.install "delatex"
    man1.install "detex.1"
  end

  test do
    (testpath/"test.tex").write <<~'TEX'
      \documentclass{article}
      \begin{document}
      Simple \emph{text}.
      \end{document}
    TEX

    output = shell_output("#{bin}/detex test.tex")
    assert_equal "Simple text.\n", output
  end
end
