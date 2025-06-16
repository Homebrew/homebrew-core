class Miniprot < Formula
  desc "Align proteins to genomes with splicing and frameshift"
  homepage "https://lh3.github.io/miniprot/"
  url "https://github.com/lh3/miniprot/archive/refs/tags/v0.17.tar.gz"
  sha256 "afdad05d18290756a7056ca7f67a91bd55d56006100653fd3dd956652206a415"
  license "MIT"

  no_autobump! because: :requires_manual_review

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "b9fdb99ed4c69aa105f0a39f5d204dd70df9f509cfa75821c8a7cefd9708d9bb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f19e488427dfb8e2f89216bfb7ef047a8ad6dc00aaef26ccfeeb173b90104438"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c289a3481809603ca712b7eddff0a8fc648cd2093bcf720e347a2964c898517a"
    sha256 cellar: :any_skip_relocation, sonoma:        "5fc06af21625d5b4d0aff8ff5b88a520b8e7b3cf4afb10bc57b07fcf324c7b39"
    sha256 cellar: :any_skip_relocation, ventura:       "4214193c715bc024cd0bcd183cc1321f52bdf6b87a82ad53cc3525a8aca696af"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a52932fbaa69027401413502c8528bc87b910a15d4344052fe20794fac812634"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "67576a73c5730d04ac0ddaee5f743accc7893e710230674223e5a342b4a3a0d5"
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
