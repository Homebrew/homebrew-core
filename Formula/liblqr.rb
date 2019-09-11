class Liblqr < Formula
  desc "C/C++ seam carving library"
  homepage "https://liblqr.wikidot.com/"
  url "https://liblqr.wdfiles.com/local--files/en:download-page/liblqr-1-0.4.2.tar.bz2"
  version "0.4.2"
  sha256 "173a822efd207d72cda7d7f4e951c5000f31b10209366ff7f0f5972f7f9ff137"
  revision 1
  head "https://repo.or.cz/liblqr.git"

  bottle do
    cellar :any
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
