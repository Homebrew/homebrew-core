class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v31.0/groestlcoin-31.0.tar.gz"
  sha256 "9c8b3004f7ed640a24acdadccace49ea123feae66ba562ca967de4119f061be3"
  license "MIT"
  revision 1
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "07bdf140bf675fc0e27f38498494c81177bfbe474c3f2aee05e65139158b1ffd"
    sha256 cellar: :any,                 arm64_sequoia: "674528d98f1699a24ba3f74422e018a0edebc20d9c6574e96208553adebc6d15"
    sha256 cellar: :any,                 arm64_sonoma:  "24dff0b09980648e208f9064cf38d11b5599f83e1160d3b62ee18dc4d2c67ad6"
    sha256 cellar: :any,                 sonoma:        "ded8d99ee833460c53afe2f05e8cb0e03d757042ae029f0666aba02257788a78"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "17d4c68e225e97d490438fe63442f3991e18e2346061bf6173d161fecd5f1ecc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5501b805d303d1514ce1c12f2ee606c76d0e96ff85d39931aa79325531c7e67d"
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
