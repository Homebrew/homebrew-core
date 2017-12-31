class Bwa < Formula
  desc "Burrow-Wheeler Aligner for pairwise alignment of DNA"
  homepage "https://github.com/lh3/bwa"
  url "https://github.com/lh3/bwa/releases/download/v0.7.17/bwa-0.7.17.tar.bz2"
  sha256 "de1b4d4e745c0b7fc3e107b5155a51ac063011d33a5d82696331ecf4bed8d0fd"

  bottle do
    cellar :any_skip_relocation
    sha256 "37fe50e4da8282601d28639f6c9dc088363ed47c9f7068a067af529bdbb02f7d" => :high_sierra
    sha256 "d43c7d65184ae3b31ea6bb3752080b6f5d52dad3cdd1492de453330b1dba219b" => :sierra
    sha256 "9c72db876f099ef599bc4d77b07dbc5935aedba837fc7cb269e331c5ebfcfef2" => :el_capitan
  end

  def install
    system "make"

    # "make install" requested 26 Dec 2017 https://github.com/lh3/bwa/issues/172
    bin.install "bwa"
    man1.install "bwa.1"
  end

  test do
    (testpath/"test.fasta").write ">0\nAGATGTGCTG\n"
    system bin/"bwa", "index", "test.fasta"
    assert_predicate testpath/"test.fasta.bwt", :exist?
    assert_match "AGATGTGCTG", shell_output("#{bin}/bwa mem test.fasta test.fasta")
  end
end
