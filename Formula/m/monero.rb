class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.5.1.tar.bz2"
  sha256 "9ec6ed0fd37db9d81cf7738a5f0536cf9aec6ed8ef8fd48649a59a6aaf20de3d"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "8e2a6c980c7ffb0df8387d6da5f3b5c825b24716f0ed5a9fc3c719ed04e10fd5"
    sha256 cellar: :any, arm64_sequoia: "24e446d719743ebb67e953937b5c692326fe9c893055e866a577dc00ba753915"
    sha256 cellar: :any, arm64_sonoma:  "f6ac488e91461fc56f78b22bbbbc767efa8bf0ce20cdc054449b0667140cd6ab"
    sha256 cellar: :any, sonoma:        "099f5345fa9c6134a96193de1adcd4aac2fca87f43ffb81d369033e93385bbdb"
    sha256 cellar: :any, arm64_linux:   "ee069aa7acd888bb2f0b66d58b93a763a6c303bc995ce951c619a45ccceb5a7d"
    sha256 cellar: :any, x86_64_linux:  "b0ad68b875452d2d06272f8dde7cf15b4bd7a23ca212601e678ecccb87f88aef"
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
