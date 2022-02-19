class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz"
  sha256 "d0e9d089b57048b1555efa7cd5a63a7ed042482045f6f33402b1df425bf9613b"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "d24ab4ebd9a10d882f5c577722c60d6c8994a6aa657824bdd26cb134a02a270b"
    sha256 cellar: :any,                 arm64_big_sur:  "787feb3307c59a0f0257ed5fde8aaa90166519b4066b50e0daa7daf1ff96c36a"
    sha256 cellar: :any,                 monterey:       "e167b6994e535259158014eec77560c12a91bf149ac99d8034d231c612a75122"
    sha256 cellar: :any,                 big_sur:        "af5526ac7b1062bcd06a98c810e099340fe533e38f4336482b932fd152b7cd68"
    sha256 cellar: :any,                 catalina:       "5f8e7e6ddb67beba6b614873080138891d6361ed7c5b72802ce92b1b58e40fa2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9d3f681d2417908d32aabbbe2167558a96692c7ba02437b0cb60454a9312914b"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost@1.76"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
    system "make", "install"
    pkgshare.install "share/rpcauth"
  end

  service do
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
