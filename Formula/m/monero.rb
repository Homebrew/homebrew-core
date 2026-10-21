class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  license "BSD-3-Clause"

  stable do
    url "https://downloads.getmonero.org/cli/monero-source-v0.18.5.4.tar.bz2"
    sha256 "3c5aabb6e8abcabb58169cf4ad60b11be23cd7384c051a40ed2b23490d842bab"

    # Backport support for OpenSSL 4
    patch do
      url "https://github.com/monero-project/monero/commit/4f73cfea6d37bc1eccab1e395fc526c94cbb99ba.patch?full_index=1"
      sha256 "246466b0ce14c4b6f2ec7f424ca80c08369a87950be9cafefeec6171dc05c9cb"
      type :backport
      resolves "https://github.com/monero-project/monero/pull/10908"
    end
  end

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "7db6efbbc0b6ed9c2abeebb2e58e6b93f7f9e779a4764cc2ff28644f6f23e4ad"
    sha256 cellar: :any, arm64_tahoe:       "040ccd211d23d19d4b744e007d830604805087e3960fdc4f15b6789cd589f786"
    sha256 cellar: :any, arm64_sequoia:     "dd99ad6352ac171d61b9d4fe5735554aa57f8538d8b2bc24bd68f06c788abed1"
    sha256 cellar: :any, arm64_linux:       "eadd8258436a09cfe253418ecc13cf05a62052bcc9d45d91e1e6141b1e1c0a46"
    sha256 cellar: :any, x86_64_linux:      "533819b7249ffe0577bd2987a98764c0a92ff70b845917d75021a65fef6b7d4c"
  end

  head do
    url "https://github.com/monero-project/monero.git", branch: "master"

    depends_on "libusb" # TODO: use on stable in 0.19 (?)
    depends_on "protobuf" # TODO: use on stable in 0.19 (?)
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@4"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

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
