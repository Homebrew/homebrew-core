class Monero < Formula
  desc "Monero: the secure, private, untraceable cryptocurrency"
  homepage "https://getmonero.org"
  url "https://github.com/monero-project/monero.git", :tag => "v0.12.0.0"

  bottle do
    sha256 "4605768a865c17daae09b3e1ddfd96babe0779126ff1ed90db26238e020d8283" => :high_sierra
    sha256 "8c2edbf826bcb23015e050ac072ff64d9d400ed0ef223b8fc53ddd14d4bb1335" => :sierra
    sha256 "6c4777177c56f4f1ef68393033421e0628a8c657cf4373ccbeb6c009c4b02430" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "openssl"
  depends_on "readline"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
  end

  test do
    cmd = "#{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, shell_output(cmd).split[-1]
  end
end
