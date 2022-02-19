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
    sha256 cellar: :any,                 arm64_monterey: "cea1a02ff1bb5c61e4de04360a3a655328b4407ceeb72047357360b026eda8b8"
    sha256 cellar: :any,                 arm64_big_sur:  "5a74f3ec6e0f5b6b9b20e57e2bc4d4c8ebf38a25c03d9c59c33c81bc193b9115"
    sha256 cellar: :any,                 monterey:       "75c4a5ee402869c8bfd25d55a064a33d333fab170873e94e65fc50bdb8d9875f"
    sha256 cellar: :any,                 big_sur:        "1f2947e941300a4429ccfd30801f206142399a7f1ec089020f332009340e8bc3"
    sha256 cellar: :any,                 catalina:       "3c0ca7cbebfdfdec4e638a169b041814c6122135283e5457144a8e9f583543b8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "057739cb63b1c5b44af1d1568b7038c7eb66c7c7b33ef3131d11f4dd65d54a90"
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
