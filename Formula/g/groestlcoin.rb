class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v28.0/groestlcoin-28.0.tar.gz"
  sha256 "4446c49916c6f2c45fcf609270318dc114e166d1c833bb7d0b51d12cb42acba6"
  license "MIT"
  revision 1
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "081c9b8f7b0acc1ac5b184d282184b299980cdbce7863e53e9fd73a1b3a71403"
    sha256 cellar: :any,                 arm64_sonoma:  "8cb6268ab3ba00c3a26a2bae6d89e83c8827958278c70659c1c53156897dc48c"
    sha256 cellar: :any,                 arm64_ventura: "3d157a563023e50da9d4a38b7c8cbcb73668e8a54a3a8f3dc565da6dd34d35ea"
    sha256 cellar: :any,                 sonoma:        "c3933f375f271824fa373475e9f5fbecafcee78086db3abe2115e47436d9a269"
    sha256 cellar: :any,                 ventura:       "c2e864659984a595df952cf0d3b473ad52593cbd8362cca17725b82d70b1afd3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdd03f4b07dd6404d873c271db80fb952fec397cfdd02e94c8d84f44cfcf679c"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "boost" => :build
  depends_on "libtool" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5"
  depends_on "libevent"
  depends_on macos: :big_sur
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "7" # fails with GCC 7.x and earlier
    cause "Requires std::filesystem support"
  end

  def install
    system "./autogen.sh"
    system "./configure", "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          *std_configure_args
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
