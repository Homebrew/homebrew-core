class Bogofilter < Formula
  desc "Mail filter via statistical analysis"
  homepage "http://bogofilter.sourceforge.net"
  url "https://downloads.sourceforge.net/project/bogofilter/bogofilter-1.2.4/bogofilter-1.2.4.tar.bz2"
  sha256 "e10287a58d135feaea26880ce7d4b9fa2841fb114a2154bf7da8da98aab0a6b4"

  bottle do
    sha256 "92301b235bfd5088a5b20fa263de2c012f31f90860f3b1b1fd93a918d93fff7c" => :sierra
    sha256 "22cdf81e4f0f6bc9b45f5e46ddcca5262141f726f425724ef3b208138fd6d528" => :el_capitan
    sha256 "b9fd5ae465526223f0ebf07db7fdb5fb25319525d79b087998b14ee7a3fbb1f6" => :yosemite
  end

  depends_on "berkeley-db"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
