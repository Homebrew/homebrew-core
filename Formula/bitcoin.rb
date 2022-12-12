class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-24.0.1/bitcoin-24.0.1.tar.gz"
  sha256 "12d4ad6dfab4767d460d73307e56d13c72997e114fad4f274650f95560f5f2ff"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "e56672fac2ad8156d7aea28336c2a04d494013e98d0b70eb610b8464992b5929"
    sha256 cellar: :any,                 arm64_monterey: "e1a4c5decd6681167e3366a1b0b828a602f5284477d45882959b1494a80243ea"
    sha256 cellar: :any,                 arm64_big_sur:  "259562fee9d95cb93899173e86086aea48eebec490d188912d134a35a1274629"
    sha256 cellar: :any,                 ventura:        "3dbb3b0eb1d558f03166ad8b031d9a7f2747dfd600338310fe318b9b7b100da9"
    sha256 cellar: :any,                 monterey:       "a83c6d1041da647995af5235fbcf12d3f548bf4a621d0cd660b7b910ecbc4e4b"
    sha256 cellar: :any,                 big_sur:        "4c0c6526ec8eda4ec15e3767d7b56f322cfdd9392f103ea3ec3386246bab8f21"
    sha256 cellar: :any,                 catalina:       "be76b3c20499a3ad4fc0318fc7875609162b77af95eb7798355296dc6884be63"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21d04d67d68a27ad0cada5606007b3c5089dfa4ef9e7439c36484351f4ef82fa"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  # berkeley db should be kept at version 4
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-osx.md
  # https://github.com/bitcoin/bitcoin/blob/master/doc/build-unix.md
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina
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
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin/"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}"
    sleep 15
    # This command will fail if we have too new a version.
    system bin/"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end
