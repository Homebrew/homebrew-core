class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "21f33258f29458a31bd6dc6a0a327adb4b3d6db08fb278523412bc721df87d20"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5834df4ad9a7423ecf68c57043cba1e7a2bf25019c4411aab91e572712828aef"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "a855e6b08506837662048f92537186adbcc1d5ae05c07276cc7ca1f3da5077f0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "60fed61196f13dc71a9175fa581dfa46fffa5e7c6f8dd8adda79e5f4188e1b6f"
    sha256 cellar: :any,                 arm64_linux:       "7bb7437c9e10b049593287fe7bfbc20c504a4dd23739252c4c92683562489762"
    sha256 cellar: :any,                 x86_64_linux:      "30e378153ccf498f21c5b79f8f5bc2858117070dc6e0cc7cac4bc0b5b32f0227"
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
