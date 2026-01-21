class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.5.tar.bz2"
  sha256 "7c2ffec3fe0e30f6d6aca4abe26f3e1179be275ee3073fa6eea535e4b163337e"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "9abda2d7e64821bb17097447405975a1eb42bd009144fcbbd59c178bd24cc38f"
    sha256 cellar: :any,                 arm64_sequoia: "aefb7aa8f7f26da42a4a74320b7fc0f50e968543b6083226a063ba49c11f29a1"
    sha256 cellar: :any,                 arm64_sonoma:  "d39731b34ffd91f59232f541bd9ae3dad2fee4b37c7bfa40693b5900a7091f50"
    sha256 cellar: :any,                 sonoma:        "38f6a3ce15bd649acc39499985d6808455f5c4141c0d41e0f2a9b441c0ebcda0"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "65f6e4d7e1c524a68b261eefbcfe77a74d34cfb85e151bf9d6fc57b4681ba2f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8900fe698480acba97ba549e930f53ff4a197eae7eae1f0a466f4c548f480533"
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
