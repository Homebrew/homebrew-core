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
    sha256 cellar: :any,                 arm64_ventura:  "45d947210f6f1bb4bbe1836ce6a3852218dc909925c12ee593f8aadf84d8c93a"
    sha256 cellar: :any,                 arm64_monterey: "d07972bb774322c1d88fa4f834dfbfc36f9cf9494dd849f8fb94286f7d650c25"
    sha256 cellar: :any,                 arm64_big_sur:  "07f9831b1766e2fddcfd6286b0e8e4c164e286e2241cbc2670f702227cc5a97a"
    sha256 cellar: :any,                 ventura:        "ebd2453adcf200b10c5574216d76b17dd0f59951720a57622c615898fe9807a9"
    sha256 cellar: :any,                 monterey:       "959d5f095bfd82de01bf34aa183a6be900f4659743d1ac50b44f100bf8ecc328"
    sha256 cellar: :any,                 big_sur:        "be3ace44a1b4bcf4e8cb11c34e455afaa030570d4af409d7fb697021710fb7ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5eac48a633510ed9382e8cf0f5a184e142c057a31ff913f96b32c98d07716960"
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
