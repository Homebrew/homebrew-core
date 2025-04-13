class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.0.tar.bz2"
  sha256 "fe982ced4603aa7e54989326e3d1830ac1a1387e99722c419e2b103b8e8aa1a0"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "eb85f0109a2b8a75d7888fceb7d2714658540820bb5545e8625b334c8b2ade58"
    sha256 cellar: :any,                 arm64_sonoma:  "ebabb00b0a6d69073525e0cc7691274c1be7967c34dc5d2f015ff95071688f45"
    sha256 cellar: :any,                 arm64_ventura: "55b26baaa10d0b1fd7c9c24c156a6f2f3e878f46a82ab207210a12125a57c7c9"
    sha256 cellar: :any,                 sonoma:        "ca2d19f91cf129a9ed3310234d74c6af39662b31b23faa0a2dc4f3fe48615549"
    sha256 cellar: :any,                 ventura:       "362849210257c951e60afe915e46c4457d248b400fc9b2ef5663544e96eefb65"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "3833fef0611d557b4d4730662482e7c7a00109d8d66f7732e55776f79af7c0d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7639287c6dc5f1a053f8c7fd182b13a77fc155fb7aa76aa0c7f325b03a7ee025"
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
  depends_on "openssl@3"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    # Partial backport for CMake 4 compatibility
    # https://github.com/monero-project/monero/commit/eb083ca423c6dc7431d3f1e2992307cfccec4a9f
    inreplace "CMakeLists.txt", "cmake_minimum_required(VERSION 3.1)",
                                "cmake_minimum_required(VERSION 3.5)"

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
