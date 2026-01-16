class Groestlcoin < Formula
  desc "Decentralized, peer to peer payment network"
  homepage "https://www.groestlcoin.org/groestlcoin-core-wallet/"
  url "https://github.com/Groestlcoin/groestlcoin/releases/download/v30.2/groestlcoin-30.2.tar.gz"
  sha256 "0428a5c7b36185770248ffe5a41ca7bc7a6ce0d6f11216e624287827d8cd29bc"
  license "MIT"
  head "https://github.com/groestlcoin/groestlcoin.git", branch: "master"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "64eb4cab5c90777cf160c7abcf67a643672c46518e859adcc8829fd43439a963"
    sha256 cellar: :any,                 arm64_sequoia: "4e9ac50eab5edc51a670ef1d3a72dff43f25ffa233be992093b188b81e7b69af"
    sha256 cellar: :any,                 arm64_sonoma:  "bdf90a22213215a8eca15c51e427e103963df73fbe41e0e2f6df87e00fe41459"
    sha256 cellar: :any,                 sonoma:        "9e517a9d0bf166f213ae9f16eaa4f6556580a875450490b783c6685fea9e643a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8337bb0bf0fd3b01d654ac45c034a9b94f778bf7ad9ce3ea8485d7bb36aa1fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "3a7ce38034127aa2762ed818eb60a1a3257f722bb855188bc232180338044933"
  end

  depends_on "boost" => :build
  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "berkeley-db@5"
  depends_on "capnp"
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
