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
    sha256 cellar: :any,                 arm64_monterey: "fddad207c0fb13f7e7c3175b09eb9486bca07d4ac837ea90094f866576d26d84"
    sha256 cellar: :any,                 arm64_big_sur:  "8ad8d2b2eb89bd075990119a5dc75dabf8526c563f10b5099a5da0e49b0cb3d5"
    sha256 cellar: :any,                 monterey:       "db261a838f35d8142c7ab979cbe5e9222d3f38d5d398ffc832b1304f54823745"
    sha256 cellar: :any,                 big_sur:        "5b399cda0c315e38d5727e06a0f7ac6ddf49ac07580d5c4523f35180e1df95d6"
    sha256 cellar: :any,                 catalina:       "970b7af23b520e92806d20073d7429df7fb35560c8d482c2961b1778cf98b80e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "96e2f525c0139457056330ead6f41350efe256978426f827a41e6fa6f3d95b49"
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
