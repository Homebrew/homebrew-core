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
    sha256 cellar: :any, arm64_golden_gate: "ab109d84c9878a6091af00c986873dba0dc1650a5e04a0d7d15453caa48c3581"
    sha256 cellar: :any, arm64_tahoe:       "d3bccb7987e9fca4a15f16de2ae6a25cd4310868bc9a812ff03d139b60e0c711"
    sha256 cellar: :any, arm64_sequoia:     "141767e41df8629a274d9e9359b33c9bfd3f720f2e9be300aa3d6dfc16fae44f"
    sha256 cellar: :any, arm64_linux:       "f09b32da169c1564e80e2d13e7b99d6ae88d843207fe65225127e13246a8c608"
    sha256 cellar: :any, x86_64_linux:      "b1914d3db8d6a2179c16df352e7b95d7594ef646cda115d8a3ae7312563e154a"
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
