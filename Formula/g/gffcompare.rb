class Gffcompare < Formula
  desc "Compare, merge and annotate GFF/GTF transcript files"
  homepage "https://ccb.jhu.edu/software/stringtie/gffcompare.shtml"
  url "https://github.com/gpertea/gffcompare/archive/refs/tags/v0.12.10.tar.gz"
  sha256 "c708798c873b83b7a3c8e5a779da885b4d24e6039eebc6990d235aa8efe77646"
  license "MIT"
  head "https://github.com/gpertea/gffcompare.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "ad288135f38fb28d89c01280587280ffa47c766c647c3ea5d29ce5cb7ec67a8c"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9b52e739d06fc61c999cb98a625df36435e0dde817ec36c5aa7b07c6c6aa7f9a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "154a78616437a2cc9c2c1282127a85b965d69cf1f294cca8d54c349d4d590fc1"
    sha256 cellar: :any_skip_relocation, sonoma:        "9a1654be46ba1adefa662e9d9a501a671a7c85eb88c4bdf926ad4b02ef8dce7d"
    sha256 cellar: :any,                 arm64_linux:   "a497f9a4839cfccf61aa18e1f1115edb8d71c9d9354c38daf6f9f3a26b3c4cc6"
    sha256 cellar: :any,                 x86_64_linux:  "498e0b1488130ef96c2af016a7366c492b3d1f280c0f2c1b9dafb2ff026ba583"
  end

  def install
    system "make", "release"
    bin.install "gffcompare", "trmap"
    pkgshare.install "examples"
  end

  test do
    cp_r (pkgshare/"examples").children, testpath
    system bin/"gffcompare", "-r", "annotation.gff", "transcripts.gtf"

    tmap = (testpath/"gffcmp.transcripts.gtf.tmap").read
    assert_match "gene55473\trna157470\tm\tSTRG.1\tSTRG.1.1", tmap
    assert_match(/Query mRNAs :\s+5 in\s+5 loci/, (testpath/"gffcmp.stats").read)

    assert_match "STRG.1.1", shell_output("#{bin}/trmap annotation.gff transcripts.gtf")
  end
end
