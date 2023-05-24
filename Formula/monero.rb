class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.2",
      revision: "e06129bb4d1076f4f2cebabddcee09f1e9e30dcc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "503eb1905ee3c346f3e9073a694bddf94c767c1be0ca81b22ff241a73ecc81da"
    sha256 cellar: :any,                 arm64_monterey: "c7e220747fa368e4c8fb524f27c2a7d3c5fbac60df2b93df6255b73f046678d0"
    sha256 cellar: :any,                 arm64_big_sur:  "3c30abd8621a3620e8699741b9bdfcb4b12dcd2d34bfa70503631312c37da81a"
    sha256 cellar: :any,                 ventura:        "0ce807fb8a3029ae96f1a681cbfb73ee73a785075eceade84d18027551a23112"
    sha256 cellar: :any,                 monterey:       "5452415a3701f17fc32afaf9bb30cd7e1a459324d78cea42f99942fce996a225"
    sha256 cellar: :any,                 big_sur:        "b6e210f67bc9554771c01842429be151d8f9a6c2d9d7cc844164f7de63e72669"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "add9c33637ac9e3b3843a516dcfb141d0082ebe90700384c3a08d8390e3149d0"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [opt_bin/"monerod", "--non-interactive"]
  end

  test do
    cmd = "yes '' | #{bin}/monero-wallet-cli --restore-deterministic-wallet " \
          "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
          "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
          "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
          "ponies sixteen refer enhanced maul aztec bemused basin'" \
          "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).lines.last.split[1]
  end
end
