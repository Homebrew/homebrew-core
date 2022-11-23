class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.1.2",
      revision: "66184f30859796f3c7c22f9497e41b15b5a4a7c9"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "3c0c8c71557e292cb8d7b28c136b9c0ae032d10cb1fc8c4d4a148a759c394635"
    sha256 cellar: :any,                 arm64_monterey: "763a62099afbbd84d9eaf1961287478e4dc6b08a2e4da5f9eca30013af99ab60"
    sha256 cellar: :any,                 arm64_big_sur:  "a0f5d0ae695f459b68df4c70638b2f374882390f14942cca3f34e4e46b99ca82"
    sha256 cellar: :any,                 ventura:        "28d7924beed98b4129b897e5531b6b2c493c0254f4c88b12884b5441c8798f8e"
    sha256 cellar: :any,                 monterey:       "ae67c3ef1c44be10478a91af4e0b1968750ce89a0a6e3d55f7feb067e3d7754f"
    sha256 cellar: :any,                 big_sur:        "261faa3cc969eb569b20f497b6d4ee65048c1d955b28e7482167807f01c4f5be"
    sha256 cellar: :any,                 catalina:       "1d69e5d5fca688f9128257d57e4209b0a97b017445aad56343fe2103f781103c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ea86654297f7d69fb1959a0b34391b324f13b2f7e6932d92120746a79386b8ec"
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
