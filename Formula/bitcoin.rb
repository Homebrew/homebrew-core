class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-23.0/bitcoin-23.0.tar.gz"
  sha256 "26748bf49d6d6b4014d0fedccac46bf2bcca42e9d34b3acfd9e3467c415acc05"
  license "MIT"
  revision 4
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "f6cf894a92fc754ea145beba3676d918518dcabe3e94ba152731d7e17aba75bd"
    sha256 cellar: :any,                 arm64_big_sur:  "ac400352429a055e239c4277361599517c8d48a5d7aa62d93f85548191bcd4c5"
    sha256 cellar: :any,                 monterey:       "7ba835979b1e23942a1064217d986f114cd2befaa1f0a9cc40dab4023110559a"
    sha256 cellar: :any,                 big_sur:        "250aaa6c856cf4adb29597bee8bff6a03157f837a9f8ffce7868aaca6c7c47dd"
    sha256 cellar: :any,                 catalina:       "5d15d68d17ef1567afd59f09004ab87ecf433b3534b5811f0aec7b34c49e6e5b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bb0cb3880b0ef7c530dc248cc7757d4618f7ef1e710b67f7afc81c761456ae29"
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
