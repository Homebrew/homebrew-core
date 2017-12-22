class Monero < Formula
  desc "Monero wallet and CPU miner"
  homepage "https://getmonero.org"
  url "https://github.com/monero-project/monero/archive/v0.11.1.0.tar.gz"
  sha256 "b5b48d3e5317c599e1499278580e9a6ba3afc3536f4064fcf7b20840066a509b"

  depends_on "cmake" => :build
  depends_on "boost"
  depends_on "readline"
  depends_on "openssl"

  def install
    system "cmake", ".", *std_cmake_args
    system "make"
    system "make", "install"
  end

  test do
    command = "#{bin}/monero-wallet-cli --restore-deterministic-wallet " \
      "--password brew-test --restore-height 1 --generate-new-wallet wallet " \
      "--electrum-seed 'baptism cousin whole exquisite bobsled fuselage left " \
      "scoop emerge puzzled diet reinvest basin feast nautical upon mullet " \
      "ponies sixteen refer enhanced maul aztec bemused basin'" \
      "--command address"
    output = `#{command}`
    address = "4BDtRc8Ym9wGzx8vpkQQvpejxBNVpjEmVBebBPCT4XqvMxW3YaCALFraiQibejyMAxUXB5zqn4pVgHVm3JzhP2WzVAJDpHf"
    assert_equal address, output.split[-1] 
  end
end
