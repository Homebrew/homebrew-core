class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.9.tar.gz"
  sha256 "5ecc10791af04fc1fd720a9a113060668426aa798d5b6c3921364213a31a5e9b"
  license "GPL-2.0-only"
  revision 14

  bottle do
    sha256 cellar: :any, arm64_golden_gate: "408441fdbfa86be4ee3468742ed12d09567d3289cf309a8ae4883c3eadb91529"
    sha256 cellar: :any, arm64_tahoe:       "580b14b0494e9f4dd266d95068afcbe829cfc8f83f20942045aacf016c7b0900"
    sha256 cellar: :any, arm64_sequoia:     "21778ecbc92fc4a0950ab80122bbb2bb9bc35b24cc8c8e7b7cacafe01ae460f0"
    sha256               arm64_linux:       "d84d2527d778b93c64c7a81b6c7457224b0f09be77942b9316182e76c4a2085a"
    sha256               x86_64_linux:      "bfe619b93fd785dc9c6246c28d3a13d6ab8278ba1d7369b8152f472fc01abee3"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on "mongo-c-driver"
  depends_on "openssl@4"
  depends_on "protobuf"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

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

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end
