class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
  sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"
  license "LGPL-3.0"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "94977eaf2a6b9c9d52f178267ba034bb2515cb2ba0a643006c10f83ab6a532b9" => :big_sur
    sha256 "5b55b5517f358ea17c882c7afcb02ef538fe032854a6a9e1f54785a35862adde" => :arm64_big_sur
    sha256 "18803ed552ae07c1998c87ba6c4ebaee1ec5eaab843c2cfa2cc3775f0b55da23" => :catalina
    sha256 "83054ddb4fffb94ea12f609a90082220a451bfdc793284d104f1fdeaf4aa8fd6" => :mojave
    sha256 "43e9b4f518364d436b53c89b1ac42e2cfdcafc47fad1ba711bd6456122e47d62" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
