class Miniprot < Formula
  desc "Align proteins to genomes with splicing and frameshift"
  homepage "https://lh3.github.io/miniprot/"
  url "https://github.com/lh3/miniprot/archive/refs/tags/v0.16.tar.gz"
  sha256 "1ec0290552a6c80ad71657a44c767c3a2a2bbcfe3c7cc150083de7f9dc4b3ed0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39c0415c8c794f2af761f7cb95624f6c78506a5de34377e267a1050669b2c33e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "df2ff4d7eb51a65a47c7dff85b7f7c1cd43f797ff305c5193ae0895af298f7db"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f39904ebe6936462b9085da494f0b34ae5d1fad683cceaf3bf00c4ccb13a4858"
    sha256 cellar: :any_skip_relocation, sonoma:        "4b28c82f409c10bdb36c3c13c6099dcd3403d0bbf412d9baa3c355f79f257a6c"
    sha256 cellar: :any_skip_relocation, ventura:       "b01af7870345d5431c97f341c6a3b85b1d0251b1a555dd517dd8d1ecab4ab2e8"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "8ebe5daf8b63da151acc89253bb7b39aa5ed97631350285cee29c3e24b985c17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f11874854e4cbbcf2ab76855067feeb33321cd860a3ef46068ce070aa7758d60"
  end

  uses_from_macos "zlib"

  def install
    system "make"
    bin.install "miniprot"
    pkgshare.install "test"
  end

  test do
    cp_r pkgshare/"test/.", testpath
    output = shell_output("#{bin}/miniprot DPP3-hs.gen.fa.gz DPP3-mm.pep.fa.gz 2>&1")
    assert_match "mapped 1 sequences", output
  end
end
