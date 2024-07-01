class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-27.1/bitcoin-27.1.tar.gz"
  sha256 "0c1051fd921b8fae912f5c2dfd86b085ab45baa05cd7be4585b10b4d1818f3da"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "4c8fa01542cbbc6d538e0ee2f4b3500c13339855b64a8dc825f935265c16060e"
    sha256 cellar: :any,                 arm64_ventura:  "9f5160acc4a3f80310c25b8fb1161150c48867ceb32b912e9cb8db42e178596e"
    sha256 cellar: :any,                 arm64_monterey: "e392e556f28356a560543a7fc931b906551d1dd6d90e0ff9bd0701591db6eeaa"
    sha256 cellar: :any,                 sonoma:         "c72491eafc0e56b05a585eba3edbc764f658ce7be5ad064e2e23068662265010"
    sha256 cellar: :any,                 ventura:        "24cdb153e7f1c37b5c6153749bc7ffe060843b994a41853461e39065de79bd30"
    sha256 cellar: :any,                 monterey:       "bc8d2fa559c22a81f5ca18ca9837dc41f6a172dacd38cd89284850bc9d6503ec"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "369369596fede974d8030866521b151667536bce4936814403c196d18b1cb06f"
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
    version "9"
    cause "Requires C++ 20"
  end

  # Skip two tests that currently fail in the brew CI
  patch do
    url "https://github.com/fanquake/bitcoin/commit/9b03fb7603709395faaf0fac409465660bbd7d81.patch?full_index=1"
    sha256 "1d56308672024260e127fbb77f630b54a0509c145e397ff708956188c96bbfb3"
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
