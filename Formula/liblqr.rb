class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "http://liblqr.wikidot.com/"
  url "https://github.com/carlobaldassi/liblqr/archive/v0.4.2.tar.gz"
  sha256 "1019a2d91f3935f1f817eb204a51ec977a060d39704c6dafa183b110fd6280b0"
  revision 1
  head "https://github.com/carlobaldassi/liblqr.git"

  bottle do
    cellar :any
    sha256 "71b84dda3f24cec54647d2ddceb5ca6fdaa181817034ef5996751ab893dce740" => :catalina
    sha256 "00910cec48716bb94fb5279eaf41a72b484cba518529f33c3fc3da27a249f72e" => :mojave
    sha256 "200c63486701a6b120c947d950bd69a65de42728c3585b275a3b7c37cf7358f8" => :high_sierra
    sha256 "9be258b912074344d3c1a1f328c505432fddf8a84dc9d3fbd641616748100a93" => :sierra
  end

  depends_on "pkg-config" => :build
  depends_on "glib"

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}"
    system "make", "install"
  end
end
