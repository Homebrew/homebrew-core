class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v31.0/groestlcoin-31.0.tar.gz"
  sha256 "9c8b3004f7ed640a24acdadccace49ea123feae66ba562ca967de4119f061be3"
  license "MIT"
  revision 2
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "72c25e729c8a29d2c9a0ef1aafc1ce9b749d8a60bc8860d430c34ab6f638df4a"
    sha256 cellar: :any, arm64_sequoia: "f4bb5e4c0a4ce081c458929747dffdb2caeaf4bbd0032dc8d2f4cb27391b9f1a"
    sha256 cellar: :any, arm64_sonoma:  "516a4ea4ba41c9b41f07978521770b87369c6f84149d95357ae3d6e48c7b4911"
    sha256 cellar: :any, sonoma:        "9a3851ed87772e9c373159bcdd6b7af60ea1cc70b4b43dd36835605eec8e3988"
    sha256 cellar: :any, arm64_linux:   "93e90580b2930bc8333460a029ffccb27d40d532132462a974b47b8c66470cd7"
    sha256 cellar: :any, x86_64_linux:  "0c3fba86dcc533a4b7742b9038b703de6a0f4438f58624ec573004e9fa8a18bb"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "capnp"
  depends_on "libevent"
  depends_on "zeromq"

  uses_from_macos "sqlite"

  on_macos do
    depends_on macos: :big_sur
  end

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
