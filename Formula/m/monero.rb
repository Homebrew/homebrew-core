class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.1.tar.bz2"
  sha256 "e70e44cae986123c39b77a89a9ee5db431c050a55cc64442993482d085104103"
  license "BSD-3-Clause"
  revision 1

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "36c1dec48948317d6f1f2cfdebceaeacb240cab24e92b8dcd84fec9d712b5cd6"
    sha256 cellar: :any,                 arm64_sonoma:  "cf2eba367463a9452e69063569cebfadc98cfee051b02817def83efa0393ae5b"
    sha256 cellar: :any,                 arm64_ventura: "a3ea857b8db7b3534ea8fa9f88607712afee7c29b57c0465f9b8f0aefc4ae7d5"
    sha256 cellar: :any,                 sonoma:        "d324b036f160ff5e8a6b7df650e3a3ad6ea7fed31bcd6a53c1e13dd302d4ffe2"
    sha256 cellar: :any,                 ventura:       "d9720dca486f75757113ed1a782f1a43d1d8d358ca23d8f3b3bb994f620e752d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "c4843d004c0c7f5b6ca3e0dc40e900e1da79dafed616b77734e5ed84938232f3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0825aa5c4b7db085bef48b141a866b320264b1b5e5364fc1319050588e6ce402"
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

  # Fix build with Boost 1.89.0, pr ref: https://github.com/monero-project/monero/pull/10036
  patch do
    url "https://github.com/monero-project/monero/commit/f61294dc6bd9fe65d584526138178a2419f3832a.patch?full_index=1"
    sha256 "c0da585e4f06c942c4be9c829fff5483f49204dcfb4258dea7f7c6dd9be5304a"
  end

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
