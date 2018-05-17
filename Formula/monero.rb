class Monero < Formula
  desc "Official monero wallet and cpu miner"
  homepage "https://getmonero.org/"
  url "https://github.com/monero-project/monero.git",
      :tag => "v0.12.0.0",
      :revision => "c29890c2c03f7f24aa4970b3ebbfe2dbb95b24eb"
  revision 2

  bottle do
    cellar :any
    sha256 "ad90379b8d68cf142427d10934377672f51ceb9af3aba9e6bb93e9582b40ee98" => :high_sierra
    sha256 "234b5c6719a1c899972ad43ee5afac208473930c242d8a46c73eb8078cd1d232" => :sierra
    sha256 "9c97ac2f8c316a18a991ec492e631f637018a45bb86d766614b95ec6cdb8b0f1" => :el_capitan
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
