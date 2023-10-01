class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d92a1f16e60b6ab6f5c5e023a215570e9352ce9d0c9a9d7209416f8cd0227ae6"
  license "GPL-2.0-only"
  revision 4

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:   "b97cb423f3ebb565b4ca6b91ca616fedb30a7f3e69b5c91c890bd0df03bcc349"
    sha256                               arm64_ventura:  "7a89f26860a047a93fdde67abbb69a9ef2a804b7de26801b25b3b5021308f713"
    sha256                               arm64_monterey: "58bf8e4c4d365bced1994769f1f4c13cec1b645287e8bc2f94c029e4391c5825"
    sha256                               arm64_big_sur:  "fce2660c9100ad52f4e58a2c0b3b16443521d1ded9fc97c8d3479c5596fee7e1"
    sha256                               ventura:        "c92d475ccdb211ba2c8691121858e1af80bd553d2a5b8cc2b215b6ebb3b24c34"
    sha256                               monterey:       "0be179f19eb86502d3462a32a87030482eb5172fb73920d5d3c8a51de3bb009b"
    sha256                               big_sur:        "8100e3de0b7189878392bb130c50b9f4c1542ce420bee526bc208c560d68136a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "befd33d57497b24f5244b1747c724f99d3ffae208ef5319bc0ee1aac0a47ed73"
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
