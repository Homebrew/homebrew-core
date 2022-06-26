class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v23.0/groestlcoin-23.0.tar.gz"
  sha256 "ea647fec40568ccb8d574f98cf5642fd0afcfb61af72cd5e83fd167e810885b3"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8bccdc0813d7919a5234933088b4bba0905444d3e01c61edea1cd8da300698d3"
    sha256 cellar: :any,                 arm64_big_sur:  "2a3beec995b7397d1bdae6c85c84d04cd3a6073d4513d1e3d75e65b882301fc5"
    sha256 cellar: :any,                 monterey:       "c4833ca54a9cfc86b354ad5d9ebe4e0222b08270b629da53fe3f181690562e40"
    sha256 cellar: :any,                 big_sur:        "bc3d72136cdc501ebb45737c857a5846f2810001fdfbeecec8f6f46c96c31e8c"
    sha256 cellar: :any,                 catalina:       "45e2c1608558470482b260f7ee9dc8439dfacdbb98c6fd14d548ee139cbe698a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c9d90eedf379fc2c28e9dc89ef5f562630146dacd6a9017ee4c85278eff0c5d1"
  end

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
