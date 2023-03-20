class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "84cd5db0e270f6c268923592eabd5cb0d1689293d9d9f6f0634af548b29f9bb4"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "dec1a78e6dde2bbd9f86db7c71af6bc20204344a73309600dad02a19a9c04e27"
    sha256 cellar: :any,                 arm64_monterey: "369bc03e7536620d462c81dbcd252ee59868d4fac3d1c9e0756ce51d9c5ddf28"
    sha256 cellar: :any,                 arm64_big_sur:  "f6e47615be89812ef189e10c90e775e3702d7f0b8392fa50e5e08f868e99de6c"
    sha256 cellar: :any,                 ventura:        "2a6d299ed92a78eae6f4cfa010ccd1d5c0f1a179f9036bae3d724e6ce60e1eb3"
    sha256 cellar: :any,                 monterey:       "4f1986994bd9c1c950cb3b04e41c6a94cd7f6ff7abe5db2bdf7751c0ec591aad"
    sha256 cellar: :any,                 big_sur:        "631635075f6ae2fcfdc9cccd5ad73bda5ed22616fe1f2d412bb0cd9410add200"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4eecbde2f55c9e3df9f834cd4c75d50768c46d2d18a28e69e5216da178a80267"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
    depends_on "libpcap"
  end

  fails_with gcc: "5"

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DENABLE_CUSTOM_BOOST_BUILD=FALSE",
                    "-DDO_NOT_USE_SYSTEM_LIBRARIES_FOR_BUILD=FALSE",
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

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon.dat", testpath/"fastnetmon.dat"

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon_ipv6.dat", testpath/"fastnetmon_ipv6.dat"

    fastnetmon_pid = fork do
      exec opt_sbin/"fastnetmon",
           "--configuration_file",
           testpath/"fastnetmon.conf",
           "--log_to_console",
           "--disable_pid_logic"
    end

    sleep 15

    assert_path_exists testpath/"fastnetmon.dat"

    ipv4_stats_output = (testpath/"fastnetmon.dat").read
    assert_match("Incoming traffic", ipv4_stats_output)

    assert_path_exists testpath/"fastnetmon_ipv6.dat"

    ipv6_stats_output = (testpath/"fastnetmon_ipv6.dat").read
    assert_match("Incoming traffic", ipv6_stats_output)
  ensure
    Process.kill "SIGTERM", fastnetmon_pid
  end
end
