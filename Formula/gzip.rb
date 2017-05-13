class Gzip < Formula
  desc "Popular GNU data compression program"
  homepage "https://www.gnu.org/software/gzip"
  url "https://ftp.gnu.org/gnu/gzip/gzip-1.8.tar.gz"
  mirror "https://ftpmirror.gnu.org/gzip/gzip-1.8.tar.gz"
  sha256 "1ff7aedb3d66a0d73f442f6261e4b3860df6fd6c94025c2cb31a202c9c60fe0e"

  bottle do
    cellar :any_skip_relocation
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
