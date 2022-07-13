class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.3.2",
      revision: "424e4de16b98506170db7b0d7d87a79ccf541744"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "1cd9037bda11ddbb6beda326d2fd0c2d3128672fcdde4b3cd19c33087267cc0e"
    sha256 cellar: :any,                 arm64_big_sur:  "32857a9b2af7fe6d0a58c1b2dd02cf1d09f116e22e3333f5961a1b7897cc8a65"
    sha256 cellar: :any,                 monterey:       "6e7e3255e45ebc5e7ee09b5b325e752d8b958bed6177be79b718af49a3ee303e"
    sha256 cellar: :any,                 big_sur:        "403b0ffb0f18e80fc1b78f9d937fe8508c28334f038d5cb61394b360eff3a717"
    sha256 cellar: :any,                 catalina:       "f9f350521e7a1d7c6028a371710176fa783a87efac77a3ad16c88432c8171451"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a6f8b60afa38ea929bde9caf30af31c8bea4137bbf037a1e4a7593a205641619"
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
