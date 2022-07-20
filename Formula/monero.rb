class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.0.0",
      revision: "b6a029f222abada36c7bc6c65899a4ac969d7dee"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "8237f6c726ede68f6abcde6dc3161883833668c79823076a9fe5bf8de1096db1"
    sha256 cellar: :any,                 arm64_big_sur:  "8b3cc32acb3acef7fc9b765259311cf764b0a3386dc131d133fe183d798ee852"
    sha256 cellar: :any,                 monterey:       "c1ccfe473ff7b3ce3d16a40e3c915c4a5ba8adb287f9e1c9ac5fdc64c20a5f50"
    sha256 cellar: :any,                 big_sur:        "8f05b09b63be032604dab79305ed08f6ffffbf6dc90c276c1ec9a9df5e2b365d"
    sha256 cellar: :any,                 catalina:       "8fa24475f9063fb97bc924354cc28bbfe8ff50f66f603c80e2f6648ebf4ea6b5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "54253c655cd635074054c246d584a8270b59b8923df3ad9db092f05a79057501"
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "hidapi"
  depends_on "libsodium"
  depends_on "openssl@1.1"
  depends_on "protobuf"
  depends_on "readline"
  depends_on "unbound"
  depends_on "zeromq"

  conflicts_with "wownero", because: "both install a wallet2_api.h header"

  def install
    system "cmake", ".", *std_cmake_args
    system "make", "install"
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
