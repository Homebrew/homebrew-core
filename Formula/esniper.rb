class Esniper < Formula
  desc "Snipe eBay auctions from the command-line"
  homepage "https://sourceforge.net/projects/esniper/"
  url "https://downloads.sourceforge.net/project/esniper/esniper/2.33.0/esniper-2-33-0.tgz"
  version "2.33"
  sha256 "c9b8b10aefe5c397d7dee4c569f87f227c6710de528b1dc402379e5b4f1793dd"

  bottle do
    cellar :any_skip_relocation
    sha256 "a1122b9ae8ad4fc569c9028761d04aaa2eab5baa8d08ef752168054053a6b663" => :sierra
    sha256 "a1ebe915803835503349a836e0cf85961cad010469cfcaae5ef9dd778adcae8d" => :el_capitan
    sha256 "1fcdf0dfcc1245addf57c16822b28e5faf94447505e46350a455b78fa7c6981d" => :yosemite
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
