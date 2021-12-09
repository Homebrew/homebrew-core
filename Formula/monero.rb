class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.3.0",
      revision: "ab18fea3500841fc312630d49ed6840b3aedb34d"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "c5ef11da201b984a0767a34e2dcfdbc3849e1267f7c06f3a0468969bfd644265"
    sha256 cellar: :any,                 arm64_big_sur:  "f397c7157d783257bb9348e216fc2395f88a4a1829704a358fc4f0020d0c0df8"
    sha256 cellar: :any,                 monterey:       "2e61e95086330b51639b5530aec47c9dff88d0eb21de2c606ec0bf7a175e9429"
    sha256 cellar: :any,                 big_sur:        "6a8fa0820db60ec3b032e904ec4a791abecff6074879f8d54b4fbffc4f403f8f"
    sha256 cellar: :any,                 catalina:       "4d7e17dcaa1bfee714b30acdabe51f1e6ecb567d89611a8926b429f094676b82"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b2c120fc94fac14c59bf202f8ffe18d09016b707bddc48097029d40a003bc136"
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
