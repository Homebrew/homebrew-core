class Pwgen < Formula
  desc "Password generator"
  homepage "https://pwgen.sourceforge.io/"
  url "https://downloads.sourceforge.net/project/pwgen/pwgen/2.08/pwgen-2.08.tar.gz"
  sha256 "dab03dd30ad5a58e578c5581241a6e87e184a18eb2c3b2e0fffa8a9cf105c97b"

  bottle do
    cellar :any_skip_relocation
    sha256 "01a0709f74923e7b86d680f03d3ec056d3175cb7e54be176a26d5bfae890fd21" => :sierra
    sha256 "7dade70b172cb91635afffe8bb1eadb251f9dbd3368ab9e4a37f98a7c0a14b01" => :el_capitan
    sha256 "1799bdbb42974d10e2ff3a4e382351b1f03f0a3be31c15ff718d8935d1226101" => :yosemite
  end

  def install
    system "./configure", "--disable-debug", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"
  end

  test do
    system "#{bin}/pwgen", "--secure", "20", "10"
  end
end
