class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.4.tar.gz"
  sha256 "84cd5db0e270f6c268923592eabd5cb0d1689293d9d9f6f0634af548b29f9bb4"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "8be6c0d421aa58f9ce3373050d9f946d0dd5487e37312a12d5f8c5daaa1eaaf1"
    sha256 cellar: :any,                 arm64_monterey: "4ce200d84d0a28bac3073c6be8eb084382732238a99fe9cbd2c0094ef7b7826f"
    sha256 cellar: :any,                 arm64_big_sur:  "e18037e32e58e0d23edc0f59804dc52c1ee0006149facfebf0f20c7ec59f1cef"
    sha256 cellar: :any,                 ventura:        "84f0ad256f7c8265c0ee15d355e2fd3ebb6c422d13588a6ff8fc65c8f6d92bc7"
    sha256 cellar: :any,                 monterey:       "8b7cde1d1a39987caf6ed51359309c937bfff25a9839a3198d34b3520d4a6e3d"
    sha256 cellar: :any,                 big_sur:        "2a735e77fd27bc3c0a06acd5cb2c82e1144565a46e6634860c4ae6ca5ab35dc2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e55038ba9fd79ef65de4695d744a8796f7cce3f4e745832273cd7c9fa853bcb9"
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
