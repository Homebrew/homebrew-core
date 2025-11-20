class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v29.0/groestlcoin-29.0.tar.gz"
  sha256 "48298150c83e38ca0b9b449c99fd1c18118849397e09261312a052517f504746"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f1a940185d12a1a8558837b49f25e1d06015460f9e3ad833d3c1e4bf87ad3678"
    sha256 cellar: :any, arm64_sequoia: "d92c1efe5b438c2356e7745b77ae3ebff9744f7ed1648e02d451f2461f40b1ab"
    sha256 cellar: :any, arm64_sonoma:  "12d1897dd611a2e0aa1bfec5eda253f83b6d30596e4043cb851b34c45d5d245e"
    sha256 cellar: :any, arm64_ventura: "02ef7614ec36e639fd496e025406afc07f69ccb03ac6ce08405610613552c294"
    sha256 cellar: :any, sonoma:        "6f7e45dd7b0e76124fcf9474e14f21697fc101671077cadf0bf49102a517f7c7"
    sha256 cellar: :any, ventura:       "dd046071e97a46de8e018c131c5b25df2ed84ca5d9b4187bbfffc536614e4bc8"
    sha256               arm64_linux:   "39ade609f64538c50e5198695a39713a3a0f959117047f311ed92c62aaa50c17"
    sha256               x86_64_linux:  "aad63fcebed9b80267c3e5525a7ebfb0a9c4ff7529239bf51502da9396ac0a6a"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5"
  depends_on "libevent"
  depends_on macos: :big_sur
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
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
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
