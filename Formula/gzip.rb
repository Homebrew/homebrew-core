class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.9.tar.gz"
  sha256 "5d2d3a3432ef32f24cdb060d278834507b481a75adeca18850c73592f778f6ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "789eed948749a668c0ed9d353b85b885f79058672d7479571950220b1edc5b0c" => :high_sierra
    sha256 "c3c1a97b0df6fdb1b3ca403b6768abf5a52c756bb4a9b29ae4c739b9bfdf2ca9" => :sierra
    sha256 "9171b2bf9290804403f96299e981b048d2dee273a0a9bbb352d1d8f30b920510" => :el_capitan
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
