class Potrace < Formula
  desc "Convert bitmaps to vector graphics"
  homepage "https://potrace.sourceforge.io/"
  url "https://potrace.sourceforge.io/download/1.15/potrace-1.15.tar.gz"
  sha256 "a9b33904ace328340c850a01458199e0064e03ccaaa731bc869a842b1b8d529d"

  bottle do
    cellar :any
    sha256 "6e28d591ada36d7099467e85219da3c27cbcc409e6dcd75952da3104588b871f" => :sierra
    sha256 "e6b0e07301f7683e0e75c0c01ca5bb19e1d7f77e6e4ef2cccdb7de84c7d48f8f" => :el_capitan
    sha256 "951776c4b7721c930b94982fb8e2f4827308f7667cb60bdb8f7a0b0f892699ff" => :yosemite
  end

  resource "head.pbm" do
    url "https://potrace.sourceforge.io/img/head.pbm"
    sha256 "3c8dd6643b43cf006b30a7a5ee9604efab82faa40ac7fbf31d8b907b8814814f"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-libpotrace"
    system "make", "install"
  end

  test do
    resource("head.pbm").stage testpath
    system "#{bin}/potrace", "-o", "test.eps", "head.pbm"
    assert File.exist? "test.eps"
  end
end
