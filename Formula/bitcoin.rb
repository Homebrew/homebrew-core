class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-23.0/bitcoin-23.0.tar.gz"
  sha256 "26748bf49d6d6b4014d0fedccac46bf2bcca42e9d34b3acfd9e3467c415acc05"
  license "MIT"
  revision 3
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "85032174d1a8fef79d83bafa0d83a8658b991de922e5d6f22e4eab8685f7bb6e"
    sha256 cellar: :any,                 arm64_big_sur:  "3a6071e17033c44f15b93df3d40c0a8ce3839fcc9459734b89e816af0dec3b43"
    sha256 cellar: :any,                 monterey:       "bdaf808516f2d8e20d51781df622b0c8f7352b6b1d0ad8c2154c90435c04012e"
    sha256 cellar: :any,                 big_sur:        "905774fb45316d1ca5e8188ee38b9c8ca1d5c5fd8d6dda41c3282788e3f9289b"
    sha256 cellar: :any,                 catalina:       "2f428c157c1b86ab696b045afdd98fc3d4c414d4d7ea90b053bbc77bfa8760d1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fe839cb818d429fc721a45777db1568bef4b3b32cd66429d7d8574dc149a1596"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina
  depends_on "miniupnpc"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "gcc"
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
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"
  end
end
