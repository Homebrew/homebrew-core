class Miniprot < Formula
  desc "Align proteins to genomes with splicing and frameshift"
  homepage "https://lh3.github.io/miniprot/"
  url "https://github.com/lh3/miniprot/archive/refs/tags/v0.18.tar.gz"
  sha256 "e1b5c08571fa3a4aa225da8ec9c6e744cd116b4dc50d9e187114cffe336921ee"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "fe77911afdb839f4f700c98bfda9570e0ff9002bb8e43700d9545f32e05f9d81"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "35ae697dab027ac299dc74dfc7ed0109df346cf602109c44b1f352a3aa893a8b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "2d2f623ee332800fbfd668d5963794b04fc3928f52d06619010fa55bf3202dc4"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5bd7639bb06c91ed42b6497544a1efadf1c1d8d16bbe3b07d818e35bed4d355e"
    sha256 cellar: :any_skip_relocation, sonoma:        "d7b50b18273f1f1e1325e84459f438088aebb0db0e8e97affd8058bfb7c515e9"
    sha256 cellar: :any_skip_relocation, ventura:       "e8b3a3abea6ef7abdb8597bdc54f916a8f4000b743ca34b46a68dcf4deb74355"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5c95a98c7fda96b04f0a62b24b8c55b75742851044ef81d088d126f9cb36bcab"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ea05612a87b1d5a4dbd1763e2d2fb190e24cc9203d36449a292e4da1bd2d048e"
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
