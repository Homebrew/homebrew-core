class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.3.2",
      revision: "424e4de16b98506170db7b0d7d87a79ccf541744"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8c2ec3498bce1d4ddbf8c91d68e3d4873a179ca94b988480ac0e386cc618da66"
    sha256 cellar: :any,                 arm64_big_sur:  "be790370b452889fb37479443f9633c0fe84968c882f7283570f8155bc479ae1"
    sha256 cellar: :any,                 monterey:       "66a4cc186141dd36d32a49a024e7675ed349a29a7929ca4895b9eb530211f831"
    sha256 cellar: :any,                 big_sur:        "0543ac8a9c09f4491a36f035ebf84f6a31e220e75b39f037a8f33a854bd81338"
    sha256 cellar: :any,                 catalina:       "b468595a61d1030bddaf1ab44490a753e48b08d020da3f6c5623a9105c815247"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f82ebfdccb69176a3a86625c8ccb94a89af264d175f1065ac0142663e60557ba"
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
