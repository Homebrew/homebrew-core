class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.3",
      revision: "81d4db08eb75ce5392c65ca6571e7b08e41b7c95"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "cb39ced3e963a69194a95171d84bc44055606cc3c53c66598eef89427908df80"
    sha256 cellar: :any,                 arm64_ventura:  "c313a080c3596b65f383712ff5fdff7b534f289467179fdcc92e497a3e1467e8"
    sha256 cellar: :any,                 arm64_monterey: "b6d9f4ba1795bc9c8bce32c8388b528ed78b159ad1c85e2cdf8de386cd44dc7e"
    sha256 cellar: :any,                 sonoma:         "4c8e1ad2262fabd0176b130a36c9aa367879c3cf5df6e399080f41a8f4a37d84"
    sha256 cellar: :any,                 ventura:        "f7bf5addea65f6f713efe8075e4ce4527782f22d120a627ba95856873d668492"
    sha256 cellar: :any,                 monterey:       "375c6ef36ae4fd34831177d6300bfa4f3e357959570be71b84ab816797800285"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3e348d14f790b457f9624b9b3805e22f3538bccaf2f3a528f480c1e04e1e115b"
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
    # Work around build error with Boost 1.85.0
    # Issue ref: https://github.com/monero-project/monero/issues/9304
    ENV.append "CXXFLAGS", "-include boost/numeric/conversion/bounds.hpp"
    copy_option_files = %w[
      src/common/boost_serialization_helper.h
      src/p2p/net_peerlist.cpp
      src/wallet/wallet2.cpp
    ]
    inreplace copy_option_files, "boost::filesystem::copy_option::overwrite_if_exists",
                                 "boost::filesystem::copy_options::overwrite_existing"

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
