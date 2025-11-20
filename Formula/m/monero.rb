class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.4.tar.bz2"
  sha256 "84570eee26238d8f686605b5e31d59569488a3406f32e7045852de91f35508a2"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "7366ef831969cdfdd20ee245dfff54b7ff513f88cac9a19dccf47ffd2ae3fb16"
    sha256 cellar: :any,                 arm64_sequoia: "336771bc78c17793cb33ba8ce22d5202defd85277761bc6b92dab0ff128eeaee"
    sha256 cellar: :any,                 arm64_sonoma:  "3382822035f7d5135ab8ccbe2e8ce16a39da2acf2863a5cbda980992f4d60ea0"
    sha256 cellar: :any,                 sonoma:        "171d4705917e1c3bbdf270da3e3b2cf5b9308c81b69ece3262c8dbd81ea5a571"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a8a642fe9c1d0713002b4e56d3b2bf0b2667e8454f1d1dbbbad2c5b5fb99982e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "37e63fa14697b11a5454c16691bf9e24e91a91140cbb0db9a5664e75cfee6edb"
  end

  head do
    url "https://github.com/monero-project/monero.git", branch: "master"

    depends_on "libusb" # TODO: use on stable in 0.19 (?)
    depends_on "protobuf" # TODO: use on stable in 0.19 (?)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

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
