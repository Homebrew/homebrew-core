class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-26.0/bitcoin-26.0.tar.gz"
  sha256 "ab1d99276e28db62d1d9f3901e85ac358d7f1ebcb942d348a9c4e46f0fcdc0a1"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "d0062252e0c931af07ab48ccd9163d80c729c798f7b8eb4f974025e158b8b2f5"
    sha256 cellar: :any,                 arm64_ventura:  "05d45234ca89490c3867b0e0230c2b86ebc88a2ed5505887ec395776d5be20e9"
    sha256 cellar: :any,                 arm64_monterey: "20edc14418354dbc01c6602a720625c7a7ec98b3dc157ddf0d4a4c5b34ceaba4"
    sha256 cellar: :any,                 sonoma:         "87b42c2acf2b6ee314aabe41aaf603dff8c27c2aac5c933fe9118cd4ab55f621"
    sha256 cellar: :any,                 ventura:        "adfa967969a20bb8010bccca9d39a44bd0951e68e55ae37e3b4d118b45424b84"
    sha256 cellar: :any,                 monterey:       "448df06d285427ba72234be9dae4a240efa4024b0eb8076f38b48cca184e6a7d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "79ddee5896e3df6a980dc57819aea4ed567b0c1db6451e5f4a3680b7ab3da0d6"
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

  patch do
    url "https://github.com/bitcoin/bitcoin/commit/e1e3396b890b79d6115dd325b68f456a0deda57f.patch?full_index=1"
    sha256 "b9bb2d6d2ae302bc1bd3956c7e7e66a25e782df5dc154b9d2b17d28b23fda1ad"
  end

  patch do
    url "https://github.com/bitcoin/bitcoin/commit/9c144154bd755e3765a51faa42b8849316cfdeb9.patch?full_index=1"
    sha256 "caeb3c04eda55b260272bfbdb4f512c99dbf2df06b950b51b162eaeb5a98507a"
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
