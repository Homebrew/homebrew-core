class Monero < Formula
  desc "Official Monero wallet and CPU miner"
  homepage "https://www.getmonero.org/downloads/#cli"
  url "https://downloads.getmonero.org/cli/monero-source-v0.18.4.2.tar.bz2"
  sha256 "e9ec2062b3547db58f00102e6905621116ab7f56a331e0bc9b9e892607b87d24"
  license "BSD-3-Clause"

  livecheck do
    url "https://downloads.getmonero.org/cli/source"
    strategy :header_match
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "a12667101d0a4ec5d75dfe8c6decaabdd72d1ed14d222079cfc19295b5fab2c6"
    sha256 cellar: :any,                 arm64_sequoia: "63458779ec8c4185b021361ca624162d0fb40d27f06a66ac60aedaa0d9f80407"
    sha256 cellar: :any,                 arm64_sonoma:  "11caef7b0eae3e41b38666c229b7e1f4322f110bab7cab0cd32dd89d1e84b375"
    sha256 cellar: :any,                 arm64_ventura: "5f65bc0ca66623fb0da584d72c3e0658a224349fd986e225a0d68e86c1908db4"
    sha256 cellar: :any,                 sonoma:        "36896518b1e339f32d52da76d3b31fb6b0048d41222990cc58076f59ef6118d1"
    sha256 cellar: :any,                 ventura:       "0b325f46374785eee8c8fa430582f8bfa1e207e0168f5ea21b9505528104e192"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f2caa97db728719b76a468f7cd96153dd89de6100d643c6f02c15ee65272da42"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0a7638a239505ca25130fac091e7a2fca6aee3e918a37617db3a1f7d89e492c0"
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
