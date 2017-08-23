class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "e88158208ed6ec2d97abc95658c3f0f577edc3a94d019ec31efdcd260faabdd3" => :sierra
    sha256 "216d1f95c2536709a1177941f319f9659646af0585f9f2a1e7eb12f0eebee675" => :el_capitan
    sha256 "13186e723f2b5124a0acb2bfb23f5f4e57194944f9458b4c141811e14aa27e7f" => :yosemite
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "openssl"

  needs :cxx11

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
