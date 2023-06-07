class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d92a1f16e60b6ab6f5c5e023a215570e9352ce9d0c9a9d7209416f8cd0227ae6"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "766d36f3912a3cee0e95d22b5e97fc813f3484fc145c180cfc7eaa150ab30cf5"
    sha256 cellar: :any,                 arm64_monterey: "f399e55f4f1dfbee466c82f27128cbc37aa2df1164491afc34af2e87d6908116"
    sha256 cellar: :any,                 arm64_big_sur:  "1bf91512a6addb3b71d57879bb0439baa15d8a6c704e60fb5070d238b003224a"
    sha256 cellar: :any,                 ventura:        "10a9772b6dba1cd001609150c112c469da2859258b34b6922887b5309782bdac"
    sha256 cellar: :any,                 monterey:       "5631cf00a21e09c5d6f82e51597cd64e82fb16073cfe9f46d4573b2e95668511"
    sha256 cellar: :any,                 big_sur:        "ed20ea53d33be8086144019a0aca53493eb97a49b90b9a1100eec8ca1bd8f419"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f16861d43e05722b63ff4acc2257893bdd584cd5ca0cadbca684abf72ae934e2"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc@1.54"
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

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon.dat", (testpath/"fastnetmon.dat").to_s

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon_ipv6.dat", (testpath/"fastnetmon_ipv6.dat").to_s

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
