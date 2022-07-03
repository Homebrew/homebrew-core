class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "4de0fe9390673f7e2fc8f3f1e3696a1455ea659049430c4870fcf82600c2ea2d"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "7a8b7501e874d14519610b1248facae6490f5ba81042f082b1766b1272a545c7"
    sha256 cellar: :any,                 arm64_big_sur:  "757e6391d4c293c0865f9218e74743450fc7d7f7a1ae264400c605fb8737fa97"
    sha256 cellar: :any,                 monterey:       "9c927ce604be69fddc74180d6dba21afe47f4c857f14fedd99781ede7fb1729e"
    sha256 cellar: :any,                 big_sur:        "4438cdb8fd7787afdb92b177b0b48f59ceba73de5197365b4a67b727cfc8f08c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b4bb4d0d9bbb59bff4ac804984d4fec3812a3a681986ce68de7f2912b2612911"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "json-c"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "gcc"
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
