class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  license "MIT"
  revision 2
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  stable do
    url "https://github.com/Groestlcoin/groestlcoin/releases/download/v31.0/groestlcoin-31.0.tar.gz"
    sha256 "9c8b3004f7ed640a24acdadccace49ea123feae66ba562ca967de4119f061be3"

    # Backport for newer Boost
    patch do
      url "https://github.com/Groestlcoin/groestlcoin/commit/0bc9d354dfd8074d1c36a891a69b6585a8775c65.patch?full_index=1"
      sha256 "3f163d9775d4f80e559c28bd5a0c58586b25cb9fe08ec9340d5950355476b477"
      type :backport
    end
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "f842203ed324c75c80f81e5cbe5bae4e0897a50524e8dc3f6506b446362689a3"
    sha256 cellar: :any, arm64_tahoe:       "5603249caca6b7e2d060f652d92c48af4a9a8cf5d609d28af72069d780ce71e2"
    sha256 cellar: :any, arm64_sequoia:     "e66e7156c3a7e83f287b038652c93d4c2fc0f9b1757fe1022b7055cb60e8564f"
    sha256 cellar: :any, arm64_linux:       "5f48f10d3e82eab428618f95b1c337e179d66374c37f720c7dd7c6e419b3975f"
    sha256 cellar: :any, x86_64_linux:      "b5417c6f7990e0db0b1dad5689862a0dfa5ae08eeb66b058e7b5352b6734dc78"
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
