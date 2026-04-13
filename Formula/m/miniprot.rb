class Miniprot < Formula
  desc "Align proteins to genomes with splicing and frameshift"
  homepage "https://lh3.github.io/miniprot/"
  url "https://github.com/lh3/miniprot/archive/refs/tags/v0.18.tar.gz"
  sha256 "e1b5c08571fa3a4aa225da8ec9c6e744cd116b4dc50d9e187114cffe336921ee"
  license "MIT"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e2df4ada405138f554ac6e7bf27bad4b7eaf1c5a7d4fbc9a54d6eb1434778fb8"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ddaab716a69014a0aefec396d7fd02f2d21e8b44bdb43c9dbac8cb570e4fea6f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "029ca5d5ddfa03fa93b1b9a91977908a0206ae58a21b151f2010c61193de6cc6"
    sha256 cellar: :any_skip_relocation, sonoma:        "8992d1199cfdd4651e55658118c5025c031f35c774e383e2520720ccf90c4e64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "61e3d4664c87b3cdf856c24bdf9d82cdf7ffcef6c057818ba96fc803faab4e58"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5dbb2fde218797475adc93a169cd0e7b8b6388a6af963ddc43cb165ed15bb43d"
  end

  on_linux do
    depends_on "zlib-ng-compat"
  end

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
