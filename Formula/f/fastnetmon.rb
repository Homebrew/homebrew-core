class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "3e669dbbf48bf3d39116ee4fb824b9dd01f86a92289ba7944e712d71bbcb3247"
    sha256 cellar: :any,                 arm64_ventura:  "711d8259e10e57c1efa16b6b4155415967ec51259021a6b83f5e18bbf2c1a83f"
    sha256 cellar: :any,                 arm64_monterey: "ce06e7e3c956b51c8d06cc1ab53563d44df8649da9bdb7869e98d7a28ed122e5"
    sha256 cellar: :any,                 sonoma:         "a6e465c7ebd3a4e10c6fb3985b872c296ae8c0e6ac10599a7af09f926d0a1458"
    sha256 cellar: :any,                 ventura:        "3d3c6ec3091dbc3cd5323932b5903e84d22850fd656c8e31173f476564589324"
    sha256 cellar: :any,                 monterey:       "a7b56df101c3996ca9630592d09f08cb79395d1f2b44f53a27da0f2cd6c83213"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3308d0e385a43c089ee390764a405facaa57def032b742624003dd7bc5010225"
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
  depends_on "openssl@3"
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
