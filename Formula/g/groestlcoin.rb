class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v27.0/groestlcoin-27.0.tar.gz"
  sha256 "cf8de03ef104e67aa7c0c1f69fd78e19ea6fa3e8187d890d7916c1c72a3be530"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "40bae4088292ac22e77b60cc99a83d538c281a7d94bf2ee2466cc7975b319c54"
    sha256 cellar: :any,                 arm64_ventura:  "18cd32907ee3d648759cef09403911b9c38c58bea8c69e666c5008bb3f9ec8bf"
    sha256 cellar: :any,                 arm64_monterey: "d303d76c742e6d6f80c16394b318388cb57795da1ca13db288163f9282b4c0fe"
    sha256 cellar: :any,                 sonoma:         "23b6d0947f9895cb9974137dc24ae92c304d6017926c714257d9654c5f5e4d84"
    sha256 cellar: :any,                 ventura:        "118c66a388597c33c4eb976e48bb68671527efc3e27c92c1c800f74112ceaee8"
    sha256 cellar: :any,                 monterey:       "53b23a96a82c60fd48372a6b46bba388defd029275312192267310045def39a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3a07a117acf2e654c599b1b4d3916d42e0c3d9cdb7b13da8f184a3fa4123ea97"
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
