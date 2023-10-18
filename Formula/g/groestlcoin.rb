class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v25.0/groestlcoin-25.0.tar.gz"
  sha256 "23d27c2135cce492d7680b1b939ee2dbae1d56df9eb161301e3712eaaa94988e"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "654cf2fcd91ae68cef262de33d7363033e70581b7c18c81534843b845c3d2087"
    sha256 cellar: :any,                 arm64_ventura:  "8df27e0a9ad72e4641f117dd09343d2af38e7425a9d564faab54fa4235fbd6ad"
    sha256 cellar: :any,                 arm64_monterey: "f6e9c3d1f8c170b0db451b7309141128a60cb4a88179ebdf317be99fcf8f85d3"
    sha256 cellar: :any,                 arm64_big_sur:  "46960b1e46dd3cf020da8afebf573dad45e17c485e2ce8b7cb78c8a8486b5908"
    sha256 cellar: :any,                 sonoma:         "99dac6681fabef69342d99bf72d87f5a9fea249bc23a50837657d9e7b73d60da"
    sha256 cellar: :any,                 ventura:        "e06a712aa0c6d318c287963d3802302b8b6cc9310320b70a471d69b2573aa36a"
    sha256 cellar: :any,                 monterey:       "352b6b249dbab2f9a2cf6fd2a38989c8cd382336b2a6d98e3dc18d1514e21e05"
    sha256 cellar: :any,                 big_sur:        "a677d317e7cc24d8494bbb87a5e2b2687866904f0e58a834ba71ae0c95dfe419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41aa13541849d8604d738e061455de9ca12b70b755f203c7550afda3bb5c8951"
  end

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "pkg-config" => :build
  depends_on "berkeley-db@5"
  depends_on "boost"
  depends_on "libevent"
  depends_on macos: :catalina # groestlcoin requires std::filesystem, which is only supported from Catalina onwards.
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
    run opt_bin/"groestlcoind"
  end

  test do
    system bin/"groestlcoin-tx", "-txid", "0100000001000000000000000000000000000000000000000000000000000" \
                                          "0000000000000ffffffff0a510101062f503253482fffffffff0100002cd6" \
                                          "e2150000232103e26025c37d6d0d968c9dabcc53b029926c3a1f9709df97c" \
                                          "11a8be57d3fa0599cac00000000"
  end
end
