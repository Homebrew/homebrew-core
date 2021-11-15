class Bitcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://bitcoincore.org/"
  url "https://bitcoincore.org/bin/bitcoin-core-22.0/bitcoin-22.0.tar.gz"
  sha256 "d0e9d089b57048b1555efa7cd5a63a7ed042482045f6f33402b1df425bf9613b"
  license "MIT"
  head "https://github.com/bitcoin/bitcoin.git", branch: "master"

  livecheck do
    url "https://bitcoincore.org/en/download/"
    regex(/latest version.*?v?(\d+(?:\.\d+)+)/i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "e8518c5eff6958237409b99a4281e0dcf30c5fbd3a61f6558fa1b51310aaef9f"
    sha256 cellar: :any,                 arm64_big_sur:  "9421b8a1746299d909b14410991c9d11735dc47b9315d15b5ee38565cad0ae45"
    sha256 cellar: :any,                 monterey:       "8948c2404b7cffd74fe7bf979313a236349d397f92b6c0043c1a249918eb833c"
    sha256 cellar: :any,                 big_sur:        "a326a566321b9f5b8d86499fcabb246fb7bdbded956791d9293a97705c0bdb12"
    sha256 cellar: :any,                 catalina:       "59227888c3021090ea60dda9c54b80447d956e42325abb552e0f343cdaf334cc"
    sha256 cellar: :any,                 mojave:         "12b6d4af2123df56dd5d421153a9901d97ad79b8af81660905446cf1fb592573"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bc56082efef1d5c21ae17ae78f8510beb7bfbec3ed65df626fd4b67308afcc57"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@4"
  depends_on "boost"
  depends_on "libevent"
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
    system "./configure", "--disable-dependency-tracking",
                          "--disable-silent-rules",
                          "--with-boost-libdir=#{Formula["boost"].opt_lib}",
                          "--prefix=#{prefix}"
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
