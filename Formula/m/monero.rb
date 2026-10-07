class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  license "BSD-3-Clause"
  revision 1

  stable do
    url "https://downloads.getmonero.org/cli/monero-source-v0.18.5.3.tar.bz2"
    sha256 "57f8bf5a32b0f8862e6826e7e19a911294d953eae630d2b8c05a976d4dced880"

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
    sha256 cellar: :any, arm64_golden_gate: "b436138bcd53e431122245b1cae09afc3212949a1751452d83bf698da69531d1"
    sha256 cellar: :any, arm64_tahoe:       "0277fe6840e0411b8ca6db37e7413a30d78c7e94e6e30a4b7a45378c30c5d1d4"
    sha256 cellar: :any, arm64_sequoia:     "aae9a4a2305f6088d961b78f2c06255d7ea02a409c57c5a85cfe6202fcb57348"
    sha256 cellar: :any, arm64_linux:       "97a830d81c90a87fe532a350541ff09f1bd01910871d97c71d27d998e0a5e449"
    sha256 cellar: :any, x86_64_linux:      "9c07c25a1fb1b97389692eedd0ca5c9ab6092005a155337cb98c6bc97e9bdc3f"
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
