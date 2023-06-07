class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  # TODO: Check if we can use unversioned `protobuf` at version bump
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.2.2",
      revision: "e06129bb4d1076f4f2cebabddcee09f1e9e30dcc"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "aeb944e6f1d6151805257139fbabfee79a99b7f5d82f03ef8fbbd4d8ce9242ac"
    sha256 cellar: :any,                 arm64_monterey: "7845ad54160a43e4b227d361d7641c80845772f4d59955db1643891b4c6d9ba3"
    sha256 cellar: :any,                 arm64_big_sur:  "17f4238c70bde49fe64f84e21522c03e0776c29c5039bfc96940e9fed846277e"
    sha256 cellar: :any,                 ventura:        "008753881f30a313b282608e481c31ce4d2edb377eb5a1605672d5d58812e3b8"
    sha256 cellar: :any,                 monterey:       "25533c83b05e1d1405c6879c2b70f4aee91566d9263eece346b6186e1ccc3da4"
    sha256 cellar: :any,                 big_sur:        "f19d7b064966e87d5efc86ff93f11974113c695fdd140ad6252b55db3f1cf7fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f90d56e09feafcf4e8cf6734b0fbe2a4b353e32e55712a96ec4634f895610dd5"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "libusb"
  depends_on "openssl@1.1"
  depends_on "protobuf@21"
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
