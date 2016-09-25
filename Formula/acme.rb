class Acme < Formula
  desc "Crossassembler for multiple environments"
  homepage "https://web.archive.org/web/20150520143433/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/"
  url "https://www.mirrorservice.org/sites/ftp.cs.vu.nl/pub/minix/distfiles/backup/acme091src.tar.gz"
  mirror "http://ftp.lip6.fr/pub/minix/distfiles/backup/acme091src.tar.gz"
  version "0.91"
  sha256 "31ed7f9be5cd27100b13d6c3e2faec35d15285542cbe168ec5e1b5236125decb"

  bottle do
    cellar :any_skip_relocation
    rebuild 2
    sha256 "a551c65f11021ede47269b1a29b09c601063267501134daa8213674a62c97615" => :sierra
    sha256 "84f0ba7e45580d5a28a9a0dd9d7a25a6e67a9bdc7407c5b91cf64b8b9cf0a165" => :el_capitan
    sha256 "1e7c7805ac21061637cd1ce964f976c6f68b9259e892ffc77ee71f2aa280f879" => :yosemite
    sha256 "022ef1a9526002dda47023b47c2af6227ee40f33b33b0ed232ae105fcf982911" => :mavericks
  end

  devel do
    url "https://web.archive.org/web/20150501011451/https://www.esw-heim.tu-clausthal.de/~marco/smorbrod/acme/current/acme093testing.tar.bz2"
    sha256 "cf374869265981437181609483bdb6c43f7313f81cfe57357b0ac88578038c02"
    version "0.93"
  end

  def install
    system "make", "-C", "src", "install", "BINDIR=#{bin}"
    doc.install Dir["docs/*"]
  end

  test do
    path = testpath/"a.asm"
    path.write <<-EOS
      !to "a.out", cbm
      * = $c000
      jmp $fce2
    EOS

    system bin/"acme", path
    code = File.open(testpath/"a.out", "rb") { |f| f.read.unpack("C*") }
    assert_equal [0x00, 0xc0, 0x4c, 0xe2, 0xfc], code
  end
end
