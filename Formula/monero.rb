class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero/archive/v0.12.0.0.tar.gz"
  sha256 "5e8303900a39e296c4ebaa41d957ab9ee04e915704e1049f82a9cbd4eedc8ffb"

  bottle do
    sha256 "d3e4de0f017590398dfe8eb9c551f533e6c3b2242deff80249d7ab58fc447612" => :high_sierra
    sha256 "dc7311d04f2f8a5eb01847c628d6e3691966bde8003a257fa3fbf71a4d14645d" => :sierra
    sha256 "1a19ec5435a0f8eaa5507a85508753d2349236117b110229d790daa7b50eb7f1" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost@1.60"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "unbound"
  depends_on "zeromq"

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.2.3.tar.gz"
    sha256 "3e6b57bf49115f4ae893b1ff7848ead7267013087dc7be1ab27636a97144d373"
  end

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq", *std_cmake_args
    system "make", "install"
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
