class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-25.0/bitcoin-25.0.tar.gz"
  sha256 "5df67cf42ca3b9a0c38cdafec5bbb517da5b58d251f32c8d2a47511f9be1ebc2"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "7964d698ce133103c43ec7e133a983028278f3d851d5382fec243215225cfec6"
    sha256 cellar: :any,                 arm64_monterey: "69954197ac4aab4ca15fea03927f9ea870563ad574ebe962548cd69c7bcd8334"
    sha256 cellar: :any,                 arm64_big_sur:  "9038890cd9c57dfe0f31a15b35a0a748c5a207fbf0a09684adcaf73cb0b0e4fd"
    sha256 cellar: :any,                 ventura:        "29a074e4a96fe7bb7c7e2a135980e6c885133abfdf6aa6669b61597d1a11b40c"
    sha256 cellar: :any,                 monterey:       "e3af0cfeba91ba9be13a49a6525add34deaf8363aa470ada08bb92c53a48f6dd"
    sha256 cellar: :any,                 big_sur:        "88c3d142ff5bb795fff54fd3724536d8572aeb4549c11dde27c8d7e4d5b71841"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2e6f19d87b4784267c1cb1a4a19236be3e8691ef2197f4c5dab6f83dd0a209c0"
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
