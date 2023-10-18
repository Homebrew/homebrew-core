class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      tag:      "v0.18.3.1",
      revision: "2656cdf5056c07684741c4425a051760b97025b0"
  license "BSD-3-Clause"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "f3fec95a2139b925780d20f8957bae54fd7444a72c1ebe856e47d38d69f18d7f"
    sha256 cellar: :any,                 arm64_ventura:  "c13ba0a80ae9e48eda8ef55ddcb08f22ef3da9e6b2283a330ea38b5b604be166"
    sha256 cellar: :any,                 arm64_monterey: "0ea9f8a1c025eec5a3f78e173f411a7b9c97eb5987e1bee69075064d4ac5f5d2"
    sha256 cellar: :any,                 sonoma:         "3dda2b16796e0c5e7fc6378238f67a8308e5a1996955b32cb9d344a098db4d37"
    sha256 cellar: :any,                 ventura:        "5d08ea51e3f3f3be0486f1f38088bbad8cad4d1d80ee5f5e1adceadefd463081"
    sha256 cellar: :any,                 monterey:       "d5bb73dd84f32b9fa5b899a2849f1eb7bafe5dedd13ae6fdff44be976bb47844"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "48ab04ddd490714d6c6149982dd87f61972baedac00882d784d89713fe36f832"
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
