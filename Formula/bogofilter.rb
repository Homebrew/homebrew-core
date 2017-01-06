class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "http://bogofilter.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-1.2.4/bogofilter-1.2.4.tar.bz2"
  sha256 "e10287a58d135feaea26880ce7d4b9fa2841fb114a2154bf7da8da98aab0a6b4"
  revision 1

  bottle do
    sha256 "142f1cd3661c3cfd50699257c8580a7d286d9b7a4aef87e19a3bb1e00bd67061" => :sierra
    sha256 "441093a1b7bd8c0336df2ac989b436c8c3c22daa590d8214d80749ded9800fad" => :el_capitan
    sha256 "b9ae4090aa642c40ff86d286b2245030b9de1b17b9fc09e51791474ff16d6efb" => :yosemite
  end

  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
