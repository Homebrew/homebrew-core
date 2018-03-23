class Libdvdcss < Formula
  desc "Access DVDs as block devices without the decryption"
  homepage "https://www.videolan.org/developers/libdvdcss.html"
  url "https://download.videolan.org/pub/videolan/libdvdcss/1.4.2/libdvdcss-1.4.2.tar.bz2"
  sha256 "78c2ed77ec9c0d8fbed7bf7d3abc82068b8864be494cfad165821377ff3f2575"

  bottle do
    cellar :any
    sha256 "a3804131e68ba89f9ef73fbfca87d52b480ee412234d4fccedb43aa70968b015" => :high_sierra
    sha256 "e3c0e3b23fc34d95e505d6a97451dc82be83463c348d7c35e0507f13c8e6ff6f" => :sierra
    sha256 "c56f02cd982d3f0e39f926693d1beba8b2bfacaef6fc29847544f120d31a2ab1" => :el_capitan
  end

  head do
    url "https://git.videolan.org/git/libdvdcss.git"
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
