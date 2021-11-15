class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.17.2.3",
      revision: "2222bea92fdeef7e6449d2d784cdfc3012641ee1"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "277c948b74a235441cfe17bf401a3c1867e464063ec5632b145f1863098e3dc4"
    sha256 cellar: :any,                 arm64_big_sur:  "13245ecf80fad0038bef6dedd713f9e97ef64c7d3985bc68dd4a8597646b4059"
    sha256 cellar: :any,                 monterey:       "f7491c58eb20dda7631ab70fa4770df2a0aa0318692ab11f9cff527af46f079d"
    sha256 cellar: :any,                 big_sur:        "bad7e328cceef655c092f5555e16a92c4c8841fc93ad8152058327be3bf8625d"
    sha256 cellar: :any,                 catalina:       "b416b9387fd77c4b8041864c590b233d1dc6645e3a6cca6c23ba7bf233b16d3c"
    sha256 cellar: :any,                 mojave:         "64fa20b4cf46cc810fd8aae3b28adaa346ba0f223a196489311eab03870df2fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d43bb2f040234a457f756d77ed4f6f596115fadd1189071e2a32f570d14ac233"
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

    # Fix conflict with miniupnpc.
    # This has been reported at https://github.com/monero-project/monero/issues/3862
    rm lib/"libminiupnpc.a"
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
