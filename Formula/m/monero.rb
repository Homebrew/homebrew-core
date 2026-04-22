class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.6.tar.bz2"
  sha256 "86668243beb87ffee3eed0a76723e4ed8a7cffd797fa59ebc2722cfc84c916a5"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9ced4ea863cdab1ad26250eaeb00295e9997e7987f104269b665ceec56c62465"
    sha256 cellar: :any,                 arm64_sequoia: "fe3b9e56524f2420dcdaf570a1e44fc40420996e11a166175c538ffcc16d69b4"
    sha256 cellar: :any,                 arm64_sonoma:  "718a73101c7820bd000f39dc93389293f5156e3656b82f63ea93c676988e0c05"
    sha256 cellar: :any,                 sonoma:        "d0a0d9484f1f31d5afd767d125b3d069225bcff3edb03ecd8975521a6ef058b9"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9b5f434faa479eaf4493cf47f4be61d9d78892fd6bf2a70868e507f617b45d55"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6cd249672c80447deec1168ebfb8d68a84ad473815d5e9ccac0c36eeaee36901"
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
