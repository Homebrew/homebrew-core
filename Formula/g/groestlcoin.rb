class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v32.1/groestlcoin-32.1.tar.gz"
  sha256 "aef409fecb3e6ed69bda4ae3405e0bd86a21e00f5092d6b05368a88917aa9b2b"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "d34bbaa065438d8624e63afffd3c9198a7565b5904b215df6d964d1fc6b5f462"
    sha256 cellar: :any, arm64_tahoe:       "8b4e6acc8d4ee2b3633fbf2d5c84b43e9b7638e72b323561dcef1447c3b27756"
    sha256 cellar: :any, arm64_sequoia:     "df2c21f43d3f730fc2f4ceb082c718d33487438006154caeab8b9a2c30a0c4e3"
    sha256 cellar: :any, arm64_linux:       "88cf7293d9e3592ece38ec19be462529f64f62a0548ff576fa442a6946df535c"
    sha256 cellar: :any, x86_64_linux:      "0891ed60fc76049c27db7812629d57c824ab2430674e7a615540397d2da8b03c"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_linux do
    depends_on "util-linux" => :build # for `hexdump`
  end

  fails_with :gcc do
    version "7" # fails with GCC 7.x and earlier
    cause "Requires std::filesystem support"
  end

  deny_network_access!

  def install
    system "cmake", "-S", ".", "-B", "build", "-DWITH_ZMQ=ON", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
