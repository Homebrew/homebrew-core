class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.2/libdvdcss-1.4.2.tar.bz2"
  sha256 "78c2ed77ec9c0d8fbed7bf7d3abc82068b8864be494cfad165821377ff3f2575"

  bottle do
    cellar :any
    sha256 "352a2c343c04e65ee38fe154c797a29cc9cca509212e2296e9cd54e3e824ce29" => :catalina
    sha256 "645422cdd6facba8137146fd12df0538b27432a72bc79c5ca8c2667ab9fc70bc" => :mojave
    sha256 "4029db91ed7536435bd29db6b67f55509be13e70b6170337edec72daad8992c4" => :high_sierra
    sha256 "907d51957c4674ddeb27b458dcf5f1f4b382219bda893fc8908147acc1c2b1ea" => :sierra
    sha256 "0aaed21ecd3c8d3b4a9997300a599de5a541689ab200a6ffce52167b2ce5b664" => :el_capitan
  end

  head do
    url "https://code.videolan.org/videolan/libdvdcss.git"
    depends_on "autoconf" => :build
    depends_on "automake" => :build
    depends_on "libtool" => :build
  end

  def install
    system "autoreconf", "-if" if build.head?
    system "./configure", "--prefix=#{prefix}", "--disable-dependency-tracking"
    system "make", "install"
  end
end
