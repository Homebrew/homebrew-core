class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.2.tar.gz"
  sha256 "4de0fe9390673f7e2fc8f3f1e3696a1455ea659049430c4870fcf82600c2ea2d"
  license "GPL-2.0-only"
  revision 8

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4874712b56f6a317241d571e9d4bee4074f274f33aba957d199472b20848d1ca"
    sha256 cellar: :any,                 arm64_monterey: "9397f1e85a14fe01376745907976ec8a37eeafc966ff6a8e13fe407cc07e75b3"
    sha256 cellar: :any,                 arm64_big_sur:  "81b7e06d431a6724e583644bf93acb7ae44adb53a607bb42c2fe824a558f6c73"
    sha256 cellar: :any,                 monterey:       "4cb65b6511be83942070039e28600819b69d7c9dc829fd577ead6878220ef76e"
    sha256 cellar: :any,                 big_sur:        "24199e0f552c17d7a47264aa6063724c0cac654d36d95257ef0907d00912ffd0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "bdd46a7180c296104f938969aca42df7e21f7e9b8b5e15405fde15c03df23d73"
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
