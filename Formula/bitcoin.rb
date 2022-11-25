class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-24.0/bitcoin-24.0.tar.gz"
  sha256 "9cfa4a9f4acb5093e85b8b528392f0f05067f3f8fafacd4dcfe8a396158fd9f4"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "3a68bac456e01f907ebcfd99052d1dd21bee6c578183ec835e26147f84011bc5"
    sha256 cellar: :any,                 arm64_monterey: "9fd296ac6a1ceeb057e054db69d75cb07ed6ab179f9be9aa46e203d71575ac79"
    sha256 cellar: :any,                 arm64_big_sur:  "488fb488a492c659af53bee662a2898a6f1df5fd1fe7b90a49e1eafd20a221f4"
    sha256 cellar: :any,                 ventura:        "ad97d1ec9d4630ae8d8eb8e9032e02859055d9da914e1468e3ba2015a8643746"
    sha256 cellar: :any,                 monterey:       "28f59efb56c19c9ffca71b3e478e6340284863c3f06443ad9147cc046b276dc2"
    sha256 cellar: :any,                 big_sur:        "ec2c1135c41d86bf22d28ae706c1fe308533f629db837982b9def8e8785d8db2"
    sha256 cellar: :any,                 catalina:       "29335f3ab42d7114c254e903498ee3dfde71baf5290c9294b707c5f4031cd111"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "60740358df872851ce702141b24c49caf71bd0913741652c9848774a7c22b539"
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
