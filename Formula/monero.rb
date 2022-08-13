class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.1.0",
      revision: "727bc5b6878170332bf2d838f2c60d1c8dc685c8"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "523c2be47fde6ab7f46f26bacc7bf77e5b1f08ad52c434908c2027ee8b075253"
    sha256 cellar: :any,                 arm64_big_sur:  "f8591ff32653ea7e2c2293c6bc53343b557f843693678015667c429878541d11"
    sha256 cellar: :any,                 monterey:       "2394940c2bd5f4e2f436c523a2293d941af3e8859b6642bede2f31a0f41dce05"
    sha256 cellar: :any,                 big_sur:        "c552280c43b388b945c2533798cb2238f431784a8f1bae2a2df5ca81db7f3758"
    sha256 cellar: :any,                 catalina:       "50e80c2bad64908f3d3674bf6084dda6f28c8a34a1f5785e31bb1b9a73917913"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "31d4263b3407bda3463c5a71ebbac05840e7c7a655ae60b1b7c2756c4473e4fb"
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
