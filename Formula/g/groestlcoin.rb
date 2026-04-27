class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v31.0/groestlcoin-31.0.tar.gz"
  sha256 "9c8b3004f7ed640a24acdadccace49ea123feae66ba562ca967de4119f061be3"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "6b34b29f95a15f5bf923243efb76bcfacdffebaeaf48f18d68753b1fb00148d6"
    sha256 cellar: :any,                 arm64_sequoia: "2600540ec34b02b0fc80027a73a041ccc2083454b9cb8bc485a233de73914585"
    sha256 cellar: :any,                 arm64_sonoma:  "a3013ba82a38cc77215374ec336a9e5d09bc39bfcb37d8a3267a7319568a61b0"
    sha256 cellar: :any,                 sonoma:        "541fc5fc553dfb721d1c75d3218ab9bafde3bf3a5620542832755ef049b5c61b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "40538f448cd3d23ff293c4c3f6453cdea3d4c799ef349b0b837896f5ab2e56a7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d914fbb52ef405a0d2b9f17e6094af2f190d93167a8eea547d163c0325b2c79"
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
