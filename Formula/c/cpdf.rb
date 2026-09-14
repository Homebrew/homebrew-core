class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bfcabf3a1e1a55840df55229afc992873b311ae50bd5a9b4135c9aef7ef91f0e"
  license "AGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "507d8223b31a815c876c8f8c9f6042cec406cb1eed955d89844c78e90db69bb7"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "884453a2717c37ba72c76a884668c8473d83c9d79070f723c553c69ec56214a4"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "67b84aa2e09ebc3d6b174491c855f6f114230a69f666f68dcbbb8a17ab425f7c"
    sha256 cellar: :any,                 arm64_linux:       "a321e27651cbf0c32da1e16b6a09f28b925c58b0c93b35f448f14e370f5789ef"
    sha256 cellar: :any,                 x86_64_linux:      "0a1b42972775cfcd12571875fedca468e7d1b06a3305c7c3a11e04d8dd608503"
  end

  depends_on "camlpdf" => :build
  depends_on "ocaml" => :build
  depends_on "ocaml-findlib" => :build

  def install
    # For OCamlmakefile
    ENV.deparallelize

    system "make", "native-code"

    bin.install "cpdf"
    man1.install "cpdf.1"
  end

  test do
    system bin/"cpdf", "-create-pdf", "-o", "out.pdf"
    assert_match version.to_s, shell_output(bin/"cpdf")
    assert_path_exists testpath/"out.pdf"
  end
end
