class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoin.org/"
  url "https://github.com/bitcoin/bitcoin/archive/v0.14.2.tar.gz"
  sha256 "e0ac23f01a953fcc6290c96799deeffb32aa76ca8e216c564d20c18e75a25219"
  head "https://github.com/bitcoin/bitcoin.git"

  bottle do
    cellar :any
    sha256 "b4c1338320ef47a7f171d47a188edb081fcf4bbd96c771ae2e2ce0b5ba6771d9" => :sierra
    sha256 "2188d4b70990c33b531e341d94154ba4f032e8410c30c01e920c4da827438d68" => :el_capitan
    sha256 "4950710da422f0278ddb4966356a6855b0cfda3b6ae3b7f57b6f1dfba8ef09ea" => :yosemite
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
