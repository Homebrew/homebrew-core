class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag => "v0.12.0.0",
      :revision => "c29890c2c03f7f24aa4970b3ebbfe2dbb95b24eb"
  revision 2

  bottle do
    sha256 "7b46a56bcb031b17d3a797c2ed867d56c1deaed9ed1aaa8f94990c0e422eada9" => :high_sierra
    sha256 "307880ddf49338dc47aae782dce07f38933edae01937e47023978e5c3709dc37" => :sierra
    sha256 "acbabbefedf0fad2b0aa863585f48c0aefc4e0dfd99c662b3b7cb11e3d331fa3" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "pkg-config" => :build
  depends_on "boost"
  depends_on "miniupnpc"
  depends_on "openssl"
  depends_on "readline"
  depends_on "zeromq"

  # Fix "fatal error: 'boost/thread/v2/thread.hpp' file not found"
  # https://github.com/monero-project/monero/pull/3667
  patch do
    url "https://github.com/monero-project/monero/commit/53a1962da18f952f6eb4683a846e52fe122520e2.patch?full_index=1"
    sha256 "c5869f9da9429047fdad4386d0310cd88aae499a9ff148120612ab52c5a20b74"
  end

  resource "cppzmq" do
    url "https://github.com/zeromq/cppzmq/archive/v4.2.3.tar.gz"
    sha256 "3e6b57bf49115f4ae893b1ff7848ead7267013087dc7be1ab27636a97144d373"
  end

  def install
    (buildpath/"cppzmq").install resource("cppzmq")
    system "cmake", ".", "-DZMQ_INCLUDE_PATH=#{buildpath}/cppzmq",
                         "-DReadline_ROOT_DIR=#{Formula["readline"].opt_prefix}",
                         *std_cmake_args
    system "make", "install"
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
