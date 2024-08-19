class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 16

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "45ffcf26723e4f7f2ce9e195e188afa610c5cdf359d8f83b81d77529b79a7759"
    sha256 cellar: :any,                 arm64_ventura:  "3764e4631dcb0edf54881dbe6b953d0608584ec7633ece3f8c0c37bb1957c17a"
    sha256 cellar: :any,                 arm64_monterey: "49b59cccc162c2ce91de3f41ec4ed22139addaba91deba69ec9e1a4350cc4933"
    sha256 cellar: :any,                 sonoma:         "cf947fb40762b1f4f5b5df0e0889275554fb7a36aa08a0d88a998dcf4a3fa35d"
    sha256 cellar: :any,                 ventura:        "2017696fff3f2c368c2216877ace9c51f79e7e2a99be564c5509b31c4dd73f95"
    sha256 cellar: :any,                 monterey:       "961a97c942b743bdb19539a0858f549355be91e2fa03b7ce8b9ce37abb480eeb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f7493797ba3206c0964a726010da3dfb9a7e9cff5eec09e002496794a6a8fe4"
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
  depends_on "openssl@3"
  depends_on "protobuf"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
    depends_on "libpcap"
  end

  fails_with gcc: "5"

  # Fix build with newer `protobuf` using open PR.
  # PR ref: https://github.com/pavel-odintsov/fastnetmon/pull/997
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/fad8757b8986226024d549a6dfb40abbab01643e.patch?full_index=1"
    sha256 "2da8dbdf9dc63df9f17067aef20d198123ce1338559d394f29461761e6b85f85"
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

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon.dat", (testpath/"fastnetmon.dat").to_s

    inreplace testpath/"fastnetmon.conf", "/tmp/fastnetmon_ipv6.dat", (testpath/"fastnetmon_ipv6.dat").to_s

    fastnetmon_pid = fork do
      exec opt_sbin/"fastnetmon",
           "--configuration_file",
           testpath/"fastnetmon.conf",
           "--log_to_console"
    end

    sleep 30

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
