class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v24.0.1/groestlcoin-24.0.1.tar.gz"
  sha256 "ff4db6305018a90973ed4686ede54b2886615d22ce7969fec41a3e861ec7d4b4"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "34567f2eeeb13aaf572044991a405b749e524dc3f3addeb2c5306bbc86eacb13"
    sha256 cellar: :any,                 arm64_monterey: "8ab43886b552bd54f09ec738c3c6e6c4ba2a5b14f3f92d9cb00eea3a758e2033"
    sha256 cellar: :any,                 arm64_big_sur:  "34f263590ffa6610682c75bacaed4e81487ceebf267192c184764ef6ee465f8d"
    sha256 cellar: :any,                 ventura:        "52deecb041d0900408e42bcb008b39957d8e7d51d163b97295d81ee7cbe6da6b"
    sha256 cellar: :any,                 monterey:       "b44e4d2f39daaa79fa0693d0fb5c0b0a9724ac0e5cda6ff4035ebf4a65361037"
    sha256 cellar: :any,                 big_sur:        "5b08e265229242c9e73f4aad6c358a4974f5c5116f939fe5c0f82ad597103295"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4358d87ee76d7a1f66644f33547244d9158a03b64eb0c8235257d5b275d9c1b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina # groestlcoin requires std::filesystem, which is only supported from Catalina onwards.
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with gcc: "5"

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
