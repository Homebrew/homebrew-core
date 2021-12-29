class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.3.0",
      revision: "ab18fea3500841fc312630d49ed6840b3aedb34d"
  license "BSD-3-Clause"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "4f067219be06a643049ea8e4089ce988df64c71d290ba22d765f840b0e724aff"
    sha256 cellar: :any,                 arm64_big_sur:  "44fc5b9a7ee3bbda3814a9b52996de2026336c84d7b2df2e1cbbb7cb5f1fa762"
    sha256 cellar: :any,                 monterey:       "eea3e891de39cefcd32755707137417bcb1a4e3cfea78f50874cab1535f8eb2b"
    sha256 cellar: :any,                 big_sur:        "eadf7f106af20240df858218a7263a51c232914b2c73f8adef706331e485129e"
    sha256 cellar: :any,                 catalina:       "45f53509ab80f8e31ab278145c9ffb2d118f7e8bfc01f75dde4e7e53b6217912"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb06cb5dea479099bcd88422f8fddb03f1bcc30796c439242d6efa9916ea9d8"
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
