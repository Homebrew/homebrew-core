class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz"
  sha256 "d0e9d089b57048b1555efa7cd5a63a7ed042482045f6f33402b1df425bf9613b"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 big_sur:      "f17b80e2eead1bbd7880688f54705b934c258830dc9a8b6a5d3dfa62f30ba99a"
    sha256 cellar: :any,                 catalina:     "078bd3d866dd676ea9d0a3168a34c3c2ffc79648d494ddf50034587236271b2e"
    sha256 cellar: :any,                 mojave:       "2e3528797ce4d82cb53871a7da4aed5eb60aff2c3f8f8a19be5cc92a4f8b0794"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "c6773a767d1cce002bb698cf1aeaee53b43607cbf5ac6e2fc904ac66cd296850"
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
    depends_on "gcc" => :build
  end

  fails_with gcc: "5"

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
