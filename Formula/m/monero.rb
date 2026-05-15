class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.5.0.tar.bz2"
  sha256 "c764dfdf6d710c8dea913e77f31d0c75a8c6a3710a448341d28c3688ad2384e5"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "caba4f09effaf65c90467fe16aed16c715a04ad225fbbde8d61aea2ac016a650"
    sha256 cellar: :any,                 arm64_sequoia: "d31f245376a00edb5a0219e291070309011a895f9afdd411fd43be612fbfd5ea"
    sha256 cellar: :any,                 arm64_sonoma:  "8f116c78c557317868cf2d24b1ae20151c6a5c5ef9a8ce312e5d6bd7bfb129c7"
    sha256 cellar: :any,                 sonoma:        "fba05fbc9c1d79da9d154d4611707f6561e6396915b341a67ac0743f0494a19a"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "cd22a130d792e134d65729337f062f811a204099f3ac6d9c1ac02d6ca3c67b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "dd72e81d741d07bb6ca33a1c5953584533995e7eb95d9efae0d21ad8ed78c7e9"
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
