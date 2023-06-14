class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.2",
      revision: "e06129bb4d1076f4f2cebabddcee09f1e9e30dcc"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0e55e08ecdc625d4b0611d4aa173d55d8dd06072b8147602aa4b78a3c964b6c4"
    sha256 cellar: :any,                 arm64_monterey: "2b3051bddacfb3727f32934b84e704a7143dece8e1d1940a4c25579082f406a4"
    sha256 cellar: :any,                 arm64_big_sur:  "de31e8caa8d348e0a7cce6b0b6326f68245fe3873874ae03c57e453a8e0d2016"
    sha256 cellar: :any,                 ventura:        "c632d362a62247ff18139d1a6adc31722367cf3a9d5e47f4855e8ac3ebe35bdb"
    sha256 cellar: :any,                 monterey:       "a629082e1d88e274e42ac8352cf8dc64db00350bd36d6f005bd25d017bb80e83"
    sha256 cellar: :any,                 big_sur:        "4c57f4f42351df3866ca7ce15a038be30da2589c1c6dcf2ab2adfb525d12e928"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "57008bbd8e2ed5af2bedf79f35e4ff1fda5a806f59b85e035dbf252d86ed627d"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
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
