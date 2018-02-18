class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftp.gnu.org/gnu/less/less-530.tar.gz"
  mirror "https://ftpmirror.gnu.org/less/less-530.tar.gz"
  sha256 "503f91ab0af4846f34f0444ab71c4b286123f0044a4964f1ae781486c617f2e2"

  bottle do
    sha256 "482f63381cba240e0e90bf9f2d970c39e30a3580e31ff49c8210d6e5a0e7d3ad" => :high_sierra
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
