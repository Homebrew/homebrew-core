class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.0.tar.bz2"
  sha256 "fe982ced4603aa7e54989326e3d1830ac1a1387e99722c419e2b103b8e8aa1a0"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "4d11233f8d872a584044b48518bec606f618408a085ed695384c7460be8f7d30"
    sha256 cellar: :any,                 arm64_sonoma:  "5700c11e92e5385aee771c6c16e91147704cc06cf170fedfad745b8b21327332"
    sha256 cellar: :any,                 arm64_ventura: "22a14172dbc0dace455ea6b87e9827647f7ce2da3ebf878624104709421924cb"
    sha256 cellar: :any,                 sonoma:        "2076e2cf86f7c12e81c2630135e68031a411c9fdc324cebf4967d68268e8059d"
    sha256 cellar: :any,                 ventura:       "e35fa36f1b4b71f23dde1d057919219cdb956560b953cb2f8bc28c9596e18788"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0da015fa3f891e47604cf0d5d43e5a66f9119ffa4d13400aa092da6fb24b8145"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd3e523b3f94f80cce7aaedffeb6ab6a5465fbe6d8d2890bf7f9b1d7fb8abf42"
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
