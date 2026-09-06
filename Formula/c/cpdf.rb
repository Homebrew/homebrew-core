class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bfcabf3a1e1a55840df55229afc992873b311ae50bd5a9b4135c9aef7ef91f0e"
  license "AGPL-3.0-only"

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_tahoe:   "194f6872ce70b4d62aeacbbc44098ebfc4c72448d99155bfcaa8a47215740c0f"
    sha256 cellar: :any, arm64_sequoia: "364ba3d8151e7e037f807d57e2e6860e1e771e677c06075d1316c1c8a3eeb161"
    sha256 cellar: :any, arm64_sonoma:  "69c46304b2c42e041b00fb57965b17542bb1623745ccc282be3895f94d64b2e4"
    sha256 cellar: :any, arm64_linux:   "b2510561cae38db489bd9b38b12d4b14ec889f4c9021178f2458af27c54661da"
    sha256 cellar: :any, x86_64_linux:  "c73545e299397b1f2c127fb969112be4762e02e6156783ad3fdebde3e752e5e0"
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
