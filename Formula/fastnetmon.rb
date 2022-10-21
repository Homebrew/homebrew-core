class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "72f364ff5557afe5670bb9444e975841bf2c2db4eb13d2425e5d2903ca8fcf22"
  license "GPL-2.0-only"

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cb74138117b205fd0785e4326277fa4a5be02f604a242782b7096b30395c4528"
    sha256 cellar: :any,                 arm64_monterey: "1c543c1dbbf305b10bd06392467592c4ec1119253a72420a0fe6a8b239c1548d"
    sha256 cellar: :any,                 arm64_big_sur:  "30ffcbd99102b8d0b4c93ab3030bc5004c5d1739097ae7b50c0f7ef72f92ad69"
    sha256 cellar: :any,                 monterey:       "a34b6feb8327ee0a96a144e547343c348a57945e8e765b600c501e96802ccc19"
    sha256 cellar: :any,                 big_sur:        "f7c18f84a8b233949d71c8a382aec8f9493cb033320e82b2e1e8fb199ea8e056"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ae301c6886451f615f0791b76a5cfa67ef5688432411e1c02bf99f2142d2bee8"
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

  # patch macOS build, remove in next release
  # upstream PR ref, https://github.com/pavel-odintsov/fastnetmon/pull/950
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/94d88b6bdfd438eaeac63f39441d4fc7e2bd76f0.patch?full_index=1"
    sha256 "0b70fd1a9e47f2f1de3580564089e355905a89f5a05bfecd6d10f5b29a7d569a"
  end

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
