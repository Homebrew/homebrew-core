class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.0.0",
      revision: "b6a029f222abada36c7bc6c65899a4ac969d7dee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "df214a6b2ae451ea85f98f0d003b90e364444abf4e4ef7c103d66f2e9a2a0b2b"
    sha256 cellar: :any,                 arm64_big_sur:  "0c1e6c031d2f6e3eadc7330a8968a9a05decfd69984f82b9ebb7fddf806b5504"
    sha256 cellar: :any,                 monterey:       "94e7316944e0ee57000c92079a30214966f3eff8d63a9cd7d96927a3f81c89e7"
    sha256 cellar: :any,                 big_sur:        "e6b033ff49441bb9a6543dae7ff095472ac7ba94f2e5d564aa4a4a92bb831f99"
    sha256 cellar: :any,                 catalina:       "94f49c2470780f7ce88f4365b5cbb8f49adf4a0006bf2f82924e2920aaaad216"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ab76bfd31dc58b33f08a3c92efe4a628d25d3b25de5ac36aa757d1b817aa0d2c"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
