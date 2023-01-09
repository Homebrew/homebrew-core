class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.1.2",
      revision: "66184f30859796f3c7c22f9497e41b15b5a4a7c9"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "12d44563e0159c54c56a4a433441caf17b1a69bf77fe85cf1963fc3b5af0cc65"
    sha256 cellar: :any,                 arm64_monterey: "be03562ce5a4ade6bcdf825fff0b88475f08e5b1451499d37e5c478eb42f7176"
    sha256 cellar: :any,                 arm64_big_sur:  "05c89492ad4e3f295422d31c786e6e9a0f29b3ed67920927458783f5182446b1"
    sha256 cellar: :any,                 ventura:        "8d65a6a36416fe84ff0136b2158a7db51356c5c552554aee70f93ee1f7f11f37"
    sha256 cellar: :any,                 monterey:       "b0cac80957b41c8643768da8c7e3b891672723966b8ade5e2162bec5ef36e1f2"
    sha256 cellar: :any,                 big_sur:        "8ff02fccba4ea1e6ce8d4e92bf3d0f10d491e14ec72c6296a98f165fa167867a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee9695530d499e3d7ff8b3cc759d7d80640b0cf8644f2fcfa35ad4277a6f7524"
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

  # patch build issue (missing includes)
  # remove in next release
  patch do
    url "https://github.com/monero-project/monero/commit/96677fffcd436c5c108718b85419c5dbf5da9df2.patch?full_index=1"
    sha256 "e39914d425b974bcd548a3aeefae954ab2f39d832927ffb97a1fbd7ea03316e0"
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
