class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.2.tar.gz"
  sha256 "bfcabf3a1e1a55840df55229afc992873b311ae50bd5a9b4135c9aef7ef91f0e"
  license "AGPL-3.0-only"

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9fdf5933da4359564e4dbd99c374d44f083fa0c932bbbe459a21a2d7d9152ec6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "67b84aa2e09ebc3d6b174491c855f6f114230a69f666f68dcbbb8a17ab425f7c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "83fa8d4bc1599719e3eda94ff93644257fe294a64881e2d4473ebbed4c463907"
    sha256 cellar: :any,                 arm64_linux:   "4cd45845c154e6b5af55038f328c4358c47571148dc6d8b87b89b98390a38cb0"
    sha256 cellar: :any,                 x86_64_linux:  "4fae20a5f2c10ab4f6ad7267c6a4b885272e8536c0e4cef7604c3d34d7427c2b"
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
