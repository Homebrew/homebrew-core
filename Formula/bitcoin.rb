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
    sha256 cellar: :any,                 arm64_monterey: "03a1fef9ff0b9bbb4450cb2cd1372e1ecb14556f055d5ed9a19f602defcf619e"
    sha256 cellar: :any,                 arm64_big_sur:  "b75972f3b02b9188543f00baa999e2160c28a4b4f0da6aef157b0cfb475a2e4f"
    sha256 cellar: :any,                 monterey:       "02d7949b8a5208327cf69494a8d0e61483fc15c1bf142392fb7ca297a644f710"
    sha256 cellar: :any,                 big_sur:        "31047dbec70ad9b1744288bdd8ad45ba5aaaf568e09acecbf1d28d7fc04bf814"
    sha256 cellar: :any,                 catalina:       "170e6afb5f62d473d0b889e7b764802c7dbf41c5247b1923676bc73a939d6294"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d4eb7f21977452955b2f1209fec120ce65d2cbedd284e6014772c54761d173b"
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
