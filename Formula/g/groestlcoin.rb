class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v26.0/groestlcoin-26.0.tar.gz"
  sha256 "45ff0c7e58e3e6cd9be4db00f8ba02566249538487f5711e64d4f0187414fb46"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "74d00da944d97d669cb3803443b414ead2ac0716110455935f7b67091e487f79"
    sha256 cellar: :any,                 arm64_ventura:  "cee9e0b484d06cda3d7c8df786a1009ffed5dfbd1a41dee4ca5dbab3824304e4"
    sha256 cellar: :any,                 arm64_monterey: "976832207e4094809adb7c5e5f025701de3c0c1383878fed5217917d59527b26"
    sha256 cellar: :any,                 sonoma:         "a809ef114796244d1ead416938fd9e8f0a8757f646caed6a3904665670697214"
    sha256 cellar: :any,                 ventura:        "8ccd403b2777f8061a2260d5352d23ab1637afcd7f17afdb06153e4c539dd85d"
    sha256 cellar: :any,                 monterey:       "0e0247ec9661cf1a11b1919ade5a8c8b59267cbacc8c40dae97114d6757bb072"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a3b8ebbea8765dad602cbd4409c3d10896657bb0ea6a973eb0f09825462fe27e"
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
