class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.2",
      revision: "e06129bb4d1076f4f2cebabddcee09f1e9e30dcc"
  license "BSD-3-Clause"
  revision 3

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "248771c9bc50bc5a7b903cfbe149982ac361a003eb6919069b622854555c913e"
    sha256 cellar: :any,                 arm64_monterey: "8ad2591d01eaca15eb20e69dcc5348ea2a0c96b0bdb4d9a13bf822d6b3a8e53d"
    sha256 cellar: :any,                 arm64_big_sur:  "7781801fa13ea21a4233ebd16f46bdfdf0a16409f385ac9e7447b1f4f9cc5972"
    sha256 cellar: :any,                 ventura:        "eb2bfd2acdc6e8f7c5ec3028a9a09fa34d5eb531dec1f74a5df5c886228bf526"
    sha256 cellar: :any,                 monterey:       "366c4fcebfe64f5bb031c1efefda3d528b47f019fc1f46a09b8db81ea7c31edf"
    sha256 cellar: :any,                 big_sur:        "ffc14524e35b93b2734fcbabc5e4fb15a2c27bf81befaccca42e8ec47e63ba56"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae2653d859456a9f0088d54784ce7e2be713c5675c8fb6443e185fbf64d36a7b"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
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
