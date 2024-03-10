class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.6.tar.gz"
  sha256 "b6a7d1e9ba98c1c042d774bff82ea3e8bbf03085e0be43a2676e41d590f668cf"
  license "GPL-2.0-only"
  revision 9

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "ce49eedbbfd453fd0e201ac494d2baca487baa01ca7a5046064f2e018459a542"
    sha256 cellar: :any,                 arm64_ventura:  "c3131082b8a55a5b3844f99c0a3835d79254e2c443ef48618c89111770900019"
    sha256 cellar: :any,                 arm64_monterey: "4350367c1d5f194b73ee7489ad72901cae7cc392888edbd135c19e532201fe3f"
    sha256 cellar: :any,                 sonoma:         "04030325463dd833f144aac0bc907a53d4356b9a8a10a8cbf3fbbe23c915adf9"
    sha256 cellar: :any,                 ventura:        "8d9b1b8160de8b503e0c8a33f6b0c76996ab2abb9932d6babca3bf8de7dcd7a7"
    sha256 cellar: :any,                 monterey:       "ae6f57f53ffbf71a25ef6066b6bd46c3d928c5b84e4325d522ab425889d27471"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "85052e6772ce25bd96a27735bdd6d6071d75c7fd04c9d6e1556063da2968881e"
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
