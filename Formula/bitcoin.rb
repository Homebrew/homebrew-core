class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-0.21.1/bitcoin-0.21.1.tar.gz"
  sha256 "caff23449220cf45753f312cefede53a9eac64000bb300797916526236b6a1e0"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any, big_sur:  "c0fc6169ebc38c3ac88562ee05f4e47f8496b4fd132e1f0c2e5f58388b3cbda3"
    sha256 cellar: :any, catalina: "cece0dd423980991501b1ab1a8d11ea1056df766ccd30dbb1ee09c1e1444a92d"
    sha256 cellar: :any, mojave:   "0ee27408b8cc28d13cb707c376287716369c6ca59d2215f0effb0a8813f3e647"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on "miniupnpc"
  depends_on "zeromq"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
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
