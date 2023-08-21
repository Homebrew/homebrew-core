class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d92a1f16e60b6ab6f5c5e023a215570e9352ce9d0c9a9d7209416f8cd0227ae6"
  license "GPL-2.0-only"
  revision 3

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "81c83f3712b5a056ed190b0639225066fcf08b4c84e219df309f43e71f24f734"
    sha256 cellar: :any,                 arm64_monterey: "fe4f2d1805139c1e7c0d2b5b4431870d55972ebd0412ae05e9b8f5ee12208ccc"
    sha256 cellar: :any,                 arm64_big_sur:  "17800806bc4e52dbf11d661059495d5cfd7850ad1ad950eaed52b089cfcb3b84"
    sha256 cellar: :any,                 ventura:        "1a108e5de92055568e1fe092a779bec815f08da43345e4db6a574e38e49ecdc8"
    sha256 cellar: :any,                 monterey:       "393c75e0894d4804d5f8d08896e1022c6992a5d24679dc4aa6a5a45577e8246e"
    sha256 cellar: :any,                 big_sur:        "c085f7a2d3a8d6e91d697de4afdc5268694448a8d7b05642f1b13815cdadbeb0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f028e8ae77dec6ae789aa1ee6598cb38aa4cfa28f970f8287d6ed7eaab0c50c4"
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
