class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.9.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.9.tar.gz"
  sha256 "5d2d3a3432ef32f24cdb060d278834507b481a75adeca18850c73592f778f6ad"

  bottle do
    cellar :any_skip_relocation
    sha256 "8c250a97a4992abbea840e20bba57ec9467d289ff3ea0ad170bb4900f6f57bd0" => :high_sierra
    sha256 "e51384ad9df99dbda85adc5ed68523661357cb038504f27a34e1851470b5416f" => :sierra
    sha256 "1fcddc90fa996157665322ea1520863e9367a97693334f4c9b60b2abcf958328" => :el_capitan
    sha256 "e240320b82c71f8367a696558a4863469b52fcb0ca8245ba0f0c83483f126507" => :yosemite
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
