class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.4",
      revision: "b089f9ee69924882c5d14dd1a6991deb05d9d1cd"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_sequoia: "af115fd44add6e1643f166d660e97281677fe318a1a25fc34371724b123330f3"
    sha256 cellar: :any,                 arm64_sonoma:  "d7e8ba33526fa789a65adaddd90eb34e7aa5ec1feca7078c067ae934b93b008d"
    sha256 cellar: :any,                 arm64_ventura: "77f99a39564dce0c36f1badb749995378b8ebdbf01f76fe9be673da530c7066a"
    sha256 cellar: :any,                 sonoma:        "9a729294d7b9ad7efbf447dc549a072fe5a5e80b76a2ab64f410dbbae1a8d70d"
    sha256 cellar: :any,                 ventura:       "0e2a9df38bb06d01d210893852e461b45198a9aa3cc303185c1b96a992f172a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "c7128d896db006e490d80a1d9fd841f5ae27861b150c2cbe9c463280ceb633eb"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@3"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  # Backport fix needed for boost 1.86.0+. Remove in the next release
  patch do
    url "https://github.com/monero-project/monero/commit/83dd5152e6d115426afbb57a94a832ec91b58a46.patch?full_index=1"
    sha256 "b727fe58ff1211080141a0b14eaf451c98b9493195f0c2d356aee7709f0c5ef6"
  end

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
