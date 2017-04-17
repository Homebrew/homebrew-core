class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftpmirror.gnu.org/less/less-487.tar.gz"
  mirror "http://www.greenwoodsoftware.com/less/less-487.tar.gz"
  sha256 "f3dc8455cb0b2b66e0c6b816c00197a71bf6d1787078adeee0bcf2aea4b12706"

  bottle do
    sha256 "a88b14210f0436da45740bf5dbf5d98559c73a74312c8b77755aa90c819fe974" => :sierra
    sha256 "1baf4050cc03e2f488fe3ce96fc41985b1e5911b15cd7b964dbdf09aebd3dceb" => :el_capitan
    sha256 "e0606d693adfae4c2bc3c4050d0f92ed4d588896ceb16e88c05f967e3e0fe90d" => :yosemite
  end

  depends_on "pcre" => :optional

  def install
    args = ["--prefix=#{prefix}"]
    args << "--with-regex=pcre" if build.with? "pcre"
    system "./configure", *args
    system "make", "install"
  end

  test do
    system "#{bin}/lesskey", "-V"
  end
end
