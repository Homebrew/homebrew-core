class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://sourceforge.net/projects/acme-crossass/"
  url "svn://svn.code.sf.net/p/acme-crossass/code-0/trunk", :revision => "97"
  version "0.96.4"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "679da82eb906eb814fc69e373fccc81d0c92563d88f2e8138cfe21eedb611c1a" => :high_sierra
    sha256 "a551c65f11021ede47269b1a29b09c601063267501134daa8213674a62c97615" => :sierra
    sha256 "84f0ba7e45580d5a28a9a0dd9d7a25a6e67a9bdc7407c5b91cf64b8b9cf0a165" => :el_capitan
    sha256 "1e7c7805ac21061637cd1ce964f976c6f68b9259e892ffc77ee71f2aa280f879" => :yosemite
    sha256 "022ef1a9526002dda47023b47c2af6227ee40f33b33b0ed232ae105fcf982911" => :mavericks
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<~EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
