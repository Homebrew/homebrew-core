class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 7

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "051dda176f5ebf67a626b52c949baafbeff1b6f5ad0cea4fde5f3acf6115a250"
    sha256 cellar: :any,                 arm64_ventura:  "fe0459a39f24be4c28ae3b8c43d8544cf929defdc8b4069fb851259a67e7a06b"
    sha256 cellar: :any,                 arm64_monterey: "ddae54f1762d9d27b6d5c68648a5d9b0c024895646b58d7c8d222b839ae243d6"
    sha256 cellar: :any,                 sonoma:         "8897cfa2dfd3ae632247c6d457c6d415cb8606cd8a9805e8c274d465ed7092f8"
    sha256 cellar: :any,                 ventura:        "56216053ab47a69f657d209abe189d4cbcb4e241c1650c93b6a45f95c8c87dd4"
    sha256 cellar: :any,                 monterey:       "e96e7b531f0635557b9462452598f0263e269ffd7266a5c0876d92d6ffc4f31a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b19bd8e816672e8826281dd08217efc303522360c16370586add82d69d5af559"
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
