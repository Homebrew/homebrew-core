class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bfcabf3a1e1a55840df55229afc992873b311ae50bd5a9b4135c9aef7ef91f0e"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a46d1a926b122d7dffd1fa8cf5df5af3d7bb003f9273177c91a8570106aee312"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "28137c1dd5eb2cca4864e2f4a29c1638fbbd10ff6f4ae33b0d77e0431c93fd4b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "0e935d992f23a9436dea4eb73b1ced23a5a03b0a4850035146d966cb73984ffb"
    sha256 cellar: :any,                 arm64_linux:       "9dea97358e80e0f96454d56c7e1b1796fa022812fe80ab99afe3e3a4ade8ab08"
    sha256 cellar: :any,                 x86_64_linux:      "250f22d9bf48b84b77702ac71b162a4a9a0811e4f676698fd2a3282ca73b4c3a"
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
