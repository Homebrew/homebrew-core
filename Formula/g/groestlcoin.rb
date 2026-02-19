class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v30.2/groestlcoin-30.2.tar.gz"
  sha256 "0428a5c7b36185770248ffe5a41ca7bc7a6ce0d6f11216e624287827d8cd29bc"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_tahoe:   "6aa0bd53c58c831218844d0fce81d6b60897016cfe45bf3429615ea28348e6a2"
    sha256 cellar: :any,                 arm64_sequoia: "7734a222a560c2aee711a526aca17a29d2104732ddaf21c8707fba4434f6c5f0"
    sha256 cellar: :any,                 arm64_sonoma:  "7de24e5a98825313bb396be429b6bb58ad27ff8bf2996e61b116b097ccdb9857"
    sha256 cellar: :any,                 sonoma:        "799c9dd04f84871cf1c2777706d2be2858879903e92cb2f63b2d305035717fce"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b1ec350575f6ad960a018cebb12b13dca0a2218dcf3ffe024e5ed5682ddb535b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a5b69b073e54f7d505985f1a3d6946410d6db15496a4a6e4ebd7c2dd59cf3e28"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on macos: :big_sur
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
