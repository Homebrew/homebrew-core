class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "5ecc10791af04fc1fd720a9a113060668426aa798d5b6c3921364213a31a5e9b"
  license "GPL-2.0-only"
  revision 5

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "b0755550508215737c6259cb11e948df4f8b50962c1620ca2ed80ef28028f31f"
    sha256 cellar: :any, arm64_sequoia: "451540265961e64eacce2c2ebc603c19993934bf41a25fb6b121bf763d32caa4"
    sha256 cellar: :any, arm64_sonoma:  "286ff286cc4d32ca75a6e4a07a8bd9ccbbc12fce9177fd7b936cfe801dd2ec48"
    sha256 cellar: :any, sonoma:        "83d8e76f92d92c68986aba17c74fd4a2ff6c9e801a9645d507d4ab7d50f84c5f"
    sha256               arm64_linux:   "2a5a98a5faa7d9bc8028b968d5497f1f56411240615a6381dd0da1fb9c8eb3c8"
    sha256               x86_64_linux:  "5a994fa2bb0be45c9ec279e258d509c376b1d25482423073fa3dbea565421d09"
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
