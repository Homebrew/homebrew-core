class Pazpar2 < Formula
  desc "Metasearching middleware webservice"
  homepage "https://www.indexdata.com/pazpar2"
  url "http://ftp.indexdata.dk/pub/pazpar2/pazpar2-1.12.6.tar.gz"
  sha256 "a03b6fe430d2d83b916975aa525178893156cb1fa478e86160acc2088a35d036"

  bottle do
    cellar :any
    sha256 "eb97500d2e2732215a178644afa9d1304f81ac0de2815cf4e55c98eccd74c79a" => :sierra
    sha256 "d5af2ca75125a99354bfde6fd4102645230bbe85a4b92831291d4555759e04d6" => :el_capitan
    sha256 "e72a4126cb415562bae2dc8c07b41fec585d521fe674910d172fb1546311fcdc" => :yosemite
    sha256 "acb104dd12781c2d6b7e8eedcaaa7b2576a890510269b561a321fc3667e1d863" => :mavericks
  end

  depends_on "pkg-config" => :build
  depends_on "icu4c" => :recommended
  depends_on "yaz"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{sbin}/pazpar2", "-V"
  end
end
