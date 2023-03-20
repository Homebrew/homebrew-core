class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.0",
      revision: "99be9a044f3854f339548e2d99c539c18d7b1b01"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "904b0d0f7c336ef446f2eabe34f2fd304c4df06d58d009e386fd3aea91f11b80"
    sha256 cellar: :any,                 arm64_monterey: "f93fa25ee187ff48c6c52d5a142b68b38eea29b029f43d0ce08c791163e0e060"
    sha256 cellar: :any,                 arm64_big_sur:  "cf5534b4d97a72d4548f31c6e72c77d2d23fbed0dc42afa09a3b3db7ea2675f2"
    sha256 cellar: :any,                 ventura:        "1ddceefba0f7005d4f21666949cc9d40ff810e5b01d6e79f2fc9ade0eb758a39"
    sha256 cellar: :any,                 monterey:       "7c3077afceba35fb82f69209b1ab2eb97b05476b787435c4ff5fb5609e5064e5"
    sha256 cellar: :any,                 big_sur:        "3e5efba2891be8dae43c0be0398e1e3da01932f4ce8344ff11fb58850bb3e43a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ba559de072d84ceb9c8a52fb6b1155ab144a6ac6ff4864bb044694f2b511de46"
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
