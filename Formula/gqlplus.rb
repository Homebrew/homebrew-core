class Gqlplus < Formula
  desc "Drop-in replacement for sqlplus, an Oracle SQL client"
  homepage "http://gqlplus.sourceforge.net/"
  url "https://downloads.sourceforge.net/project/gqlplus/gqlplus/1.15/gqlplus-1.15.tar.gz"
  sha256 "9a539cdcf952b4acd2ae2d940772366bf6c9ee0fb51846c02d3c7dc1df3056d5"

  bottle do
    cellar :any
    sha256 "db6238610872b86147a9388428049f873feb2e1cb9907b5f83cd1a1a99765999" => :el_capitan
    sha256 "e5c2b76da875f812e265298b826ae61f82feaabff0d4c168020c972392591e7d" => :yosemite
    sha256 "7d3182e52181391c1368abe4f0a5b55d337d6d4fbf44841f272724ba33094837" => :mavericks
  end

  depends_on "readline"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make"
    bin.install "gqlplus"
  end
end
