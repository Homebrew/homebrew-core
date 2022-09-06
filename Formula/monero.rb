class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.1.1",
      revision: "7cbae6ca988dedbe358ee5edbf9bdd610673a8ee"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e9c69ce2738b0a3452ad5799531ca310459def95fa35402bf94a29ad19e46d68"
    sha256 cellar: :any,                 arm64_big_sur:  "d45f26d3936b917a5610e3a767fd99f649c6cbe2881f25d58f0e4c7cdd486fad"
    sha256 cellar: :any,                 monterey:       "87be56725f455aa50a763eddaba48493eb7fb8af7dffd0afb11cfdc07d0ba7e0"
    sha256 cellar: :any,                 big_sur:        "33ea4e7c4b17a4a0c14ff1557f80758ca401035a3e6516ce36132b314ebfb68a"
    sha256 cellar: :any,                 catalina:       "ac1f99e29109e30f0ce6292a8956dc3a91676a4e588fcc2f888ec1dcdf9e9ac5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4eaa8a017a50be958f80668ae85d88fb26dc6bb30bf88d66e018ac78e4fd4a8"
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
