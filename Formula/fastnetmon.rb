class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  # TODO: Check if we can use unversioned `grpc` at version bump
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.5.tar.gz"
  sha256 "d92a1f16e60b6ab6f5c5e023a215570e9352ce9d0c9a9d7209416f8cd0227ae6"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "cfbee7fcc9c447bb72969d973f7b130a338e6802e77f9eed269389620f576d93"
    sha256 cellar: :any,                 arm64_monterey: "2dce88a68ddf802ef663443eb4a694a72c265b250d203a6b1e980f25f8e01fc7"
    sha256 cellar: :any,                 arm64_big_sur:  "26b5966e4f025903c24178723c683b3cdbfe353afb20216de6a4758f4c8da285"
    sha256 cellar: :any,                 ventura:        "4cc7dbd890eb50fe2c6469a873e10b4decc5c2130ad2328f75923ce8dd910e6c"
    sha256 cellar: :any,                 monterey:       "ab7982e2f4769464eb0ef67a81b27c6463231b40893734b1eafcc5d4a368520c"
    sha256 cellar: :any,                 big_sur:        "8d61e825bacb369d6eb524950841d328781007a27f618a96b55a4f10ca244194"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4114950c93a97ec831923b78acbbaa45b3031229c1e3bc95ef912b3cc404ca91"
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
