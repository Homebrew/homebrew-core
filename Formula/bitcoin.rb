class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "b74097eceb0623f6063b462c170245ae560fad2ef245646192fcf48f3923b0c6" => :sierra
    sha256 "9baf0f8233c2b01ad7dc77d74efdb8b1d1fd8cd6c05ee8b359ef0cd9fa497e74" => :el_capitan
    sha256 "4007af1f770c8fa77174b07c135f663451489866a3dfe306636cb010a64d88ac" => :yosemite
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

  def install
    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--prefix=#{prefix}"
    system "make", "install"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
