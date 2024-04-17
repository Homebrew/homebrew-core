class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-27.0/bitcoin-27.0.tar.gz"
  sha256 "9c1ee651d3b157baccc3388be28b8cf3bfcefcd2493b943725ad6040ca6b146b"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "9f31e1e345f50e5fa63a3fdca07115d53e556bea31b8370dcae48b23b4aabdbf"
    sha256 cellar: :any,                 arm64_ventura:  "ec9cb37c32dddd4a7cd438349a478148b3c580c0eaa732dbe9940880dfea7dcc"
    sha256 cellar: :any,                 arm64_monterey: "da3f1b6089c6e8e16c2a613f65615433c29a35287a810436a67da682e327f7b0"
    sha256 cellar: :any,                 sonoma:         "13e9e5b60b4388260104808a8fbc55181b9aa0924821963ee7170e02902c0f30"
    sha256 cellar: :any,                 ventura:        "9f542bd0ae8fe8755ca3de730b43abd5fecf49441bbd696532625c56e8cbe52a"
    sha256 cellar: :any,                 monterey:       "7bcce40dccc2940a0c9996378f1395e9b76a342575e8897b71434e8995b53639"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6694e26f630f53bc2ed624fb17bc1f5f0ede7aa99920c56f57c6e994115d95ab"
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
    run opt_bin/"bitcoind"
  end

  test do
    system "#{bin}/test_bitcoin"

    # Test that we're using the right version of `berkeley-db`.
    port = free_port
    bitcoind = spawn bin/"bitcoind", "-regtest", "-rpcport=#{port}", "-listen=0", "-datadir=#{testpath}",
                                     "-deprecatedrpc=create_bdb"
    sleep 15
    # This command will fail if we have too new a version.
    system bin/"bitcoin-cli", "-regtest", "-datadir=#{testpath}", "-rpcport=#{port}",
                              "createwallet", "test-wallet", "false", "false", "", "false", "false"
  ensure
    Process.kill "TERM", bitcoind
  end
end
