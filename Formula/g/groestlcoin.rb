class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v28.0/groestlcoin-28.0.tar.gz"
  sha256 "4446c49916c6f2c45fcf609270318dc114e166d1c833bb7d0b51d12cb42acba6"
  license "MIT"
  revision 2
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "893ac9fa8462e9ff7f6fbd6f9857780758ae0af2201284d65b7f18f6b72c1f7f"
    sha256 cellar: :any,                 arm64_sonoma:  "31c08d3a249f9e53d571051c5068816fe6224c00daec40b202e0d926761245f2"
    sha256 cellar: :any,                 arm64_ventura: "7a126eb52180581d3c66b1404cd6db1a1e647d4470645e16d7d569f60f415790"
    sha256 cellar: :any,                 sonoma:        "98bf3b941307bf031bbcdf1e0f6a22140872d642bce9e2db0741420504d5b0b5"
    sha256 cellar: :any,                 ventura:       "c916ed1c3f83bd7bccffd521b3688ec7c288a89f703a4424228cf0cbd19823eb"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "dfd80a8d2bd67a15fea6633a799eced363b66477ac5bc66b1a75d1e59047d696"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "751568f7603c64c6109ada47fd40fc2f8f32961a069f3a6c1b00307fa0355d7b"
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
    ENV.runtime_cpu_detection
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
