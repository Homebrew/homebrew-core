class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.5.1.tar.bz2"
  sha256 "9ec6ed0fd37db9d81cf7738a5f0536cf9aec6ed8ef8fd48649a59a6aaf20de3d"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "729bdcaa4a6c67915cda17b4872b703292003506880d1ccdc39bdd98e1b83475"
    sha256 cellar: :any, arm64_sequoia: "aae7d4c4adfefb5c3431ba61b564b99385f7e3a07b96d6eabc44db0c6e3887d4"
    sha256 cellar: :any, arm64_sonoma:  "5021c4b9b24bc4926b82014961e349a37c0efd54e3dcfd32fd1854b182066b60"
    sha256 cellar: :any, sonoma:        "7159a53dae72313e69e25892f2f0aa337ee7aaab24f1184e92c86f01cb2445b1"
    sha256 cellar: :any, arm64_linux:   "10ff380912f9fb17d40a49e3bbdb19298f6cbab5268621eb54fdfd52b6c3da4e"
    sha256 cellar: :any, x86_64_linux:  "7c6d6860a8ef262d4375011daab391709d560c7726778bb6a520eccaa8a2e4e7"
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
