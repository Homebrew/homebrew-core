class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v23.0/groestlcoin-23.0.tar.gz"
  sha256 "ea647fec40568ccb8d574f98cf5642fd0afcfb61af72cd5e83fd167e810885b3"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina # groestlcoin requires std::filesystem, which is only supported from Catalina onwards.
  depends_on "miniupnpc"
  depends_on "zeromq"
  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    system "./autogen.sh"
    system "./configure", *std_configure_args,
           "--disable-dependency-tracking",
           "--disable-silent-rules",
           "--without-bdb",
           "--with-boost-libdir=#{Formula["boost"].opt_lib}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"groestlcoind"
  end

  test do
    system bin/"groestlcoin-tx", "-txid", "0100000001000000000000000000000000000000000000000000000000000" \
                                          "0000000000000ffffffff0a510101062f503253482fffffffff0100002cd6" \
                                          "e2150000232103e26025c37d6d0d968c9dabcc53b029926c3a1f9709df97c" \
                                          "11a8be57d3fa0599cac00000000"
  end
end
