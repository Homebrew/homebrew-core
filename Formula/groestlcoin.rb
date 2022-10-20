class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v23.0/groestlcoin-23.0.tar.gz"
  sha256 "ea647fec40568ccb8d574f98cf5642fd0afcfb61af72cd5e83fd167e810885b3"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e271b0f7cffcc522b9b280e4f96d79aaac5aa5a89706a57575a159e67fda5215"
    sha256 cellar: :any,                 arm64_big_sur:  "0bc45052b5f441bd2cd56a3b2205066c3eb6e5c20187f06e13740def6416b210"
    sha256 cellar: :any,                 monterey:       "74770956a29628ed8c4f4f20db03947482e311d1a5b339e4006c8cb5c99da01f"
    sha256 cellar: :any,                 big_sur:        "a9109bf51667122319ebeaaacd57a9b82d5d4dd45a235691d311b42e9c9455f0"
    sha256 cellar: :any,                 catalina:       "8bdcc7cf88e1a1f8b32157e73afc17437c3714866dca1d00fd6efb3b872787bd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4afc36c84ae0165d06b1b3c773e2b3639f1005f9df171d21be2e3bcc4cf510e2"
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
