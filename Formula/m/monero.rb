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
    sha256 cellar: :any,                 arm64_sonoma:   "fd910276a984741cfc32bf18f5f1920fa8a72e5db2d976d854a0edeb0d3c1b81"
    sha256 cellar: :any,                 arm64_ventura:  "ba591223bbac418fde38f98569a887cacb929dc9fef0da8205fb0e22c3365bf0"
    sha256 cellar: :any,                 arm64_monterey: "d87d8d98d931fdbbe1f07224be2416d24d162577a6d2c658b2df05b84dd3a3e6"
    sha256 cellar: :any,                 sonoma:         "1c5db02df695dd4e218f297a0ce009a28792bc99909c9ad8f03db10a7b6934a3"
    sha256 cellar: :any,                 ventura:        "b5c26acbb37c822fa114a75b5c5cd69fa641f6d0adad9743609149a1fe0ef322"
    sha256 cellar: :any,                 monterey:       "1c1f96eaf1aa841b1892a14d9af3ca06fa4e0d995a2d3fcae6a4eb48fad4d7a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5bf12c2d90e325c7d99cee28af545f75528ec8139621d9b06b5971c4efd9699e"
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
