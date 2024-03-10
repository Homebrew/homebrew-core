class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.2",
      revision: "ef3e18b51beb937c7f786ecef0d0a0e3f6295082"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f91d4c1c58b0742ac1bd4535460d8aa84c7db3114a324963e34a4fe6a86d130d"
    sha256 cellar: :any,                 arm64_ventura:  "f5a1902360f2226581607cd43b22296a712544848e52a193e7a69fbc3a4e05b3"
    sha256 cellar: :any,                 arm64_monterey: "1d190f3fc202d0c602e032d72f90a5f1a1da879fc329858edc2a07ae57429a00"
    sha256 cellar: :any,                 sonoma:         "3fbd9c326d55af7a6dae6f8c848b05ad98962575575381ef8fbb5d4aabc537c0"
    sha256 cellar: :any,                 ventura:        "b7da5d3a6d1e1d35bc7b289feae7cb1d18df13e4a9f1cb49a3375bab49099afb"
    sha256 cellar: :any,                 monterey:       "b624be0dba2697e9e5af62a0c9f468d3be39ae1369256007e5405e3370bf1465"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a9e947896d397b88d77bf3ac730bd441ae5f509ad29795a9302cf22289e2bc57"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
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
