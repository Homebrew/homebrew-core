class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.10.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.10.tar.gz"
  sha256 "c91f74430bf7bc20402e1f657d0b252cb80aa66ba333a25704512af346633c68"

  bottle do
    cellar :any_skip_relocation
    sha256 "903289308ce89ae70f3f8116738834d2c18fed8c248c1da82fde69cdca2b34a9" => :catalina
    sha256 "9391f27b1cf04c20abb2320ba55e1f8ac186db22b7c07bf51ebccfab073f85dd" => :mojave
    sha256 "d639fe5a95eb7c0e12aa1577ca9b230cdbbd31b0ef51794d57415f9a9fa68f08" => :high_sierra
    sha256 "bfd50566283402c72d15cd87670a3fd8ea122ebbaf583bc8cfafc552340ecf70" => :sierra
  end

  def install
    system "./configure", "--disable-dependency-tracking", "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    (testpath/"foo").write "test"
    system "#{bin}/gzip", "foo"
    system "#{bin}/gzip", "-t", "foo.gz"
    assert_equal "test", shell_output("#{bin}/gunzip -c foo")
  end
end
