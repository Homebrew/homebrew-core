class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "5ecc10791af04fc1fd720a9a113060668426aa798d5b6c3921364213a31a5e9b"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "f2642762ac503b254d7f637d62a70b5d73f3f53369ea0b2e28f74d92508a1116"
    sha256 cellar: :any, arm64_sequoia: "f6336c98664920903549b7e944bf1e830f2c5cba374bf0dda5b917877c5b3815"
    sha256 cellar: :any, arm64_sonoma:  "5ce59e08dcc6f362e9f7c174c8c2c9a04a9db0c73939e75928379f40f66af63c"
    sha256 cellar: :any, sonoma:        "b4837534b9043ef1f6f44727502dca1000e224b6b72be16a66bc1370ca800139"
    sha256               arm64_linux:   "97737ca8ce01a5ca190a99178ce5e66911cac2af18492f2caacd4820e7d24158"
    sha256               x86_64_linux:  "d3857ab931b431424687d6b1b56cd6351c84e00116c92b90debb6fa4a30947b6"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on "mongo-c-driver"
  depends_on "openssl@3"
  depends_on "protobuf"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_macos do
    depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  end

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
  end

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DLINK_WITH_ABSL=ON",
                    "-DSET_ABSOLUTE_INSTALL_PATH=OFF",
                    "-DBSON_DEFAULT_IMPORTED_LIBRARY_TYPE=SHARED",
                    "-DMONGOC_DEFAULT_IMPORTED_LIBRARY_TYPE=SHARED",
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
    inreplace "fastnetmon.conf", %r{/tmp/(fastnetmon(?:_ipv6)?\.dat)}, testpath/"\\1"

    pid = spawn opt_sbin/"fastnetmon", "--configuration_file", testpath/"fastnetmon.conf", "--log_to_console"
    sleep 60
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end
