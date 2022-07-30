class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-23.0/bitcoin-23.0.tar.gz"
  sha256 "26748bf49d6d6b4014d0fedccac46bf2bcca42e9d34b3acfd9e3467c415acc05"
  license "MIT"
  revision 1
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  # Linux bottle removed for GCC 12 migration
  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c084959d808330eb564cf27b7ea51c62497a8008c2d584640466c6019bdc55b9"
    sha256 cellar: :any,                 arm64_big_sur:  "0bbf8b60af0394b210c88202c7319b785eff65635f8cbb55682793a9c674b73a"
    sha256 cellar: :any,                 monterey:       "de3f8d260583f8b12f2159358deaec0c71408cf745c250e72cc43a208c96e5a3"
    sha256 cellar: :any,                 big_sur:        "ee59dc2285d421fac229272894a9297dd97f7538995cc651839494fa184f4cdd"
    sha256 cellar: :any,                 catalina:       "225a9045c66625bb715fc92d4971f4f847ae459e22cb9e93910048f2576fe23e"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina
  depends_on "miniupnpc"
  depends_on "zeromq"

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
