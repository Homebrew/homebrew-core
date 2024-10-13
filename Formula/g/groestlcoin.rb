class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v28.0/groestlcoin-28.0.tar.gz"
  sha256 "4446c49916c6f2c45fcf609270318dc114e166d1c833bb7d0b51d12cb42acba6"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "7de5d4238e721cc097d4fa98d6ed2e49bbe507a84fd5a0541d5cc88633ddcb46"
    sha256 cellar: :any,                 arm64_sonoma:  "1ea359dbb57581a60771e9035540808ea429aa8c840bb15c45afc84977af7c80"
    sha256 cellar: :any,                 arm64_ventura: "f93b9e4a3cf6edecbbfcf241cf8244e17cd42f3dcc29259c0d47f9703a8d353d"
    sha256 cellar: :any,                 sonoma:        "dfa6da522949bb1983269cd565d36cf94a340b0f8ffdbf0e92919f594c84950a"
    sha256 cellar: :any,                 ventura:       "b6198d1cf90d785de75b3cb65048232af5e77c4e7e40bb0c9476f3aafb0271a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b3d7dd592e8bc3b2fe5f3dc9dc7ecbc2b0e5d510c1f878e560a6cfcd06175df1"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5"
  depends_on "boost"
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
    system "./configure", *std_configure_args,
           "--disable-silent-rules",
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
