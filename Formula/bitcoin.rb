class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-23.0/bitcoin-23.0.tar.gz"
  sha256 "26748bf49d6d6b4014d0fedccac46bf2bcca42e9d34b3acfd9e3467c415acc05"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "b0704a6dc3a96f5bbb71d93a468b1a4881e747e90ddfa14d6ff0d97d5a23c6eb"
    sha256 cellar: :any,                 arm64_big_sur:  "6c8caf0509daf986cd3af45eeea78789ccd4b0a8eb5aa1dfddaa624425e5b959"
    sha256 cellar: :any,                 monterey:       "2859a13d7a48dad1a6701476d66ddb0b6940dcfe4b809b1c54512d78de247e26"
    sha256 cellar: :any,                 big_sur:        "e8a1f3389faae4245c5f6a6ec8f179cb46e19af31f4e4637c6d3f24d55804b45"
    sha256 cellar: :any,                 catalina:       "3279bd808f42d6ea608d04860ac276afda7c6ac2cf5d708469d4dc66672f210a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb60fb85781435dfb545cea0c7e08339a7b3e01d60df604ccf9cba830f148e36"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost@1.76"
  depends_on "libevent"
  depends_on macos: :catalina
  depends_on "miniupnpc"
  depends_on "zeromq"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
    depends_on "gcc"
  end

  fails_with gcc: "5"

  def install
    ENV.delete("SDKROOT") if MacOS.version == :el_capitan && MacOS::Xcode.version >= "8.0"

    system "./autogen.sh"
    system "./configure", *std_configure_args,
                          "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost@1.76"].opt_lib}"
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
