class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "5ecc10791af04fc1fd720a9a113060668426aa798d5b6c3921364213a31a5e9b"
  license "GPL-2.0-only"
  revision 8

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c0249da051d69288af2dcb2ee9ad01d33062f07d130fcd83f882ea6c8fa75f37"
    sha256 cellar: :any, arm64_sequoia: "934018058824422a4be2967a3d45f87cabfc109effa92f1530a626dcf1c8a8da"
    sha256 cellar: :any, arm64_sonoma:  "30cca90dc29b1923a8b86281b43a04f7a3de3fd8e53754c89e79e79ae29a0e0d"
    sha256 cellar: :any, sonoma:        "38af1b868bb0ed8978b10a6e32ef1fc4559bcf8ec2ff21408e7b11794454c41d"
    sha256               arm64_linux:   "231b90662abb9c6efcc4dce75043eec7f4bb92f52c4fe905e34b61916995bda8"
    sha256               x86_64_linux:  "97a499eecf050e90daa59e6f0c2aab3acf377cb6142a4fd5fbf3fe00f206df35"
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
