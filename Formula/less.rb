class Less < Formula
  desc "Pager program similar to more"
  homepage "http://www.greenwoodsoftware.com/less/index.html"
  url "https://ftpmirror.gnu.org/less/less-481.tar.gz"
  mirror "http://www.greenwoodsoftware.com/less/less-481.tar.gz"
  sha256 "3fa38f2cf5e9e040bb44fffaa6c76a84506e379e47f5a04686ab78102090dda5"

  bottle do
    rebuild 2
    sha256 "5894668335c7ba7b3bce8d7e3db1fd899e05db8a251e9ac39d33dd0be94b6d88" => :sierra
    sha256 "b64e1e151c141f2d9bd67529e1c877542e337447c9aae4ab42409a38ee06e80d" => :el_capitan
    sha256 "1a3f2691a70564b5e4935d01fc6760a97a42b7a4cf372b6feb55f197925bf0d9" => :yosemite
  end

  devel do
    url "http://www.greenwoodsoftware.com/less/less-487.tar.gz"
    sha256 "f3dc8455cb0b2b66e0c6b816c00197a71bf6d1787078adeee0bcf2aea4b12706"
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
