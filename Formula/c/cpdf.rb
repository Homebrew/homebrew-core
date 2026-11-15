class Cpdf < Formula
  desc "PDF Command-line Tools"
  homepage "https://github.com/johnwhitington/cpdf-source"
  url "https://github.com/johnwhitington/cpdf-source/archive/refs/tags/v2.9.3.tar.gz"
  sha256 "21f33258f29458a31bd6dc6a0a327adb4b3d6db08fb278523412bc721df87d20"
  license "AGPL-3.0-only"
  revision 1

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "8059499ca3542482e155c6ea99547f4c3c88bfe8b9f91f2c15761869add29670"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "103a0357ee1e1fa53298a81682317154757074fb9d0b965bab01a170d257487c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "5beeaab1939e7b3765860942066bca2ac524c23a5b2eb2ed22ad7f2ce02d4f04"
    sha256 cellar: :any,                 arm64_linux:       "460cf4edef075fdedb30647d948f2ea1a0f71de54664153b81ff437810b7422d"
    sha256 cellar: :any,                 x86_64_linux:      "d434f1fce53557bcb3e5b253a75c857b655ff49bcd491e5e18d966f4af075c72"
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
