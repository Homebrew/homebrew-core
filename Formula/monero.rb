class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.2",
      revision: "e06129bb4d1076f4f2cebabddcee09f1e9e30dcc"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "ed14916b2a844aa2762df1f72928ee4820a7054d515d3c243aaa7d8e753b6f93"
    sha256 cellar: :any,                 arm64_monterey: "0ad4455c56e87026131ccda02159d40743f86cd6191d4a563d217653784c4df0"
    sha256 cellar: :any,                 arm64_big_sur:  "0ea45c2574d10a63123a2ac3eda965698374f089461c46f75f8b6883f015347b"
    sha256 cellar: :any,                 ventura:        "26887c1e49d426b5d48e6333ada84cbc7cf6b9a6a64c573831a84f1653436325"
    sha256 cellar: :any,                 monterey:       "b96e73699129ba920f20143670a227e3c2d8c1b37bb38ff252e1389bebd38671"
    sha256 cellar: :any,                 big_sur:        "8126b9a4b19701930911bc7e7ea34b14c6a34aa75b1c519e90aaad8b1b4bdafc"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f5fbca5b3ad63e6f24f9704ecaa16bc0160fa7141fc32ab947fe124f5ba091ed"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
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
