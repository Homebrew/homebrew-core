class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 13

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "94a4afafebcb477c4171204e4efb4c344337fdc423c1018fdfe344bd658a28dd"
    sha256 cellar: :any,                 arm64_sonoma:  "5cf0a95b80bcbeb28557a4ab0b4a6269fb9ddff1b29c6dd319091f578b3f41c5"
    sha256 cellar: :any,                 arm64_ventura: "e95ad2e1ee99d55f05a0f50083d7afaa662e6c728da2d50ade27785d08a4bced"
    sha256 cellar: :any,                 sonoma:        "2bf4d7fa19878783ceebc5f4bdca9496e51ac23625a8f22d65c9d484eaa7fddc"
    sha256 cellar: :any,                 ventura:       "56630066e33de6ef149915be410fcae31914111b3a29075b431cd3a3a3ad47e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9f7d1d7a2fb5c973e911e6f4639a7415e31a4b196487cd551534f3cc7f1e6fc9"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost@1.85" # Boost 1.87+ issue: https://github.com/pavel-odintsov/fastnetmon/issues/1027
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "protobuf"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
    depends_on "libpcap"
  end

  # Fix build failure with gRPC 1.67.
  # https://github.com/pavel-odintsov/fastnetmon/pull/1023
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/b6cf2e7222c24343b868986e867ddb7adad0bf30.patch?full_index=1"
    sha256 "3a3f719f7434e52db01a512ed3891cf0e3794d4576323e3c2fd3b31c69fb39be"
  end

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DLINK_WITH_ABSL=TRUE",
                    "-DSET_ABSOLUTE_INSTALL_PATH=OFF",
                    *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  service do
    run [
      opt_sbin/"fastnetmon",
      "--configuration_file",
      etc/"fastnetmon.conf",
      "--log_to_console",
      "--disable_pid_logic",
    ]
    keep_alive false
    working_dir HOMEBREW_PREFIX
    log_path var/"log/fastnetmon.log"
    error_log_path var/"log/fastnetmon.log"
  end

  test do
    cp etc/"fastnetmon.conf", testpath
    inreplace "fastnetmon.conf", %r{/tmp/(fastnetmon(?:_ipv6)?\.dat)}, "#{testpath}/\\1"

    pid = spawn opt_sbin/"fastnetmon", "--configuration_file", testpath/"fastnetmon.conf", "--log_to_console"
    sleep 60
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end
