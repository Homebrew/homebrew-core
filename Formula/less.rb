class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftp.gnu.org/gnu/less/less-487.tar.gz"
  mirror "http://www.greenwoodsoftware.com/less/less-487.tar.gz"
  sha256 "f3dc8455cb0b2b66e0c6b816c00197a71bf6d1787078adeee0bcf2aea4b12706"

  bottle do
    sha256 "9ca07bd92196f4fbf122054b3ee394f43f14173b816a5217f05661453c13dd23" => :sierra
    sha256 "877f32f255528633a67c4ae76dfda423315473a0780f8f066b7d78af4d58bbc8" => :el_capitan
    sha256 "5be9c4ad7e6eda596a6828d1f49c70612ac02e2df6a65254e99dc1a34ecf1095" => :yosemite
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
