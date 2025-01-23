class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.7.tar.gz"
  sha256 "c21fcbf970214dd48ee8aa11e6294e16bea86495085315e7b370a84b316d0af9"
  license "GPL-2.0-only"
  revision 12

  bottle do
    sha256 cellar: :any,                 arm64_sequoia: "6380d2fdfc74225a33188202240b3e1837eee93e72aabb2bbefd593772d30078"
    sha256 cellar: :any,                 arm64_sonoma:  "64589287f0db12603e4fe671567afd9c15cf05f2c9e3f1cc7b1ea2ab3013315d"
    sha256 cellar: :any,                 arm64_ventura: "6160dff946cadac6865affd5a080e01a65370f62977bffe97fbb4ba31f04f3fb"
    sha256 cellar: :any,                 sonoma:        "6d9461193a60bb736f357054ffe1decc6c6a9f1056067d44a5a45f08ebda9196"
    sha256 cellar: :any,                 ventura:       "c78087aef9648f6bddeb631bb67703f1dedcdc4d9e64efd238a7adf7f7a3d7c7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "09f741470e37c1632331c4c30262d7b15fecb6ed0d6e16dae8105cf5cf337fe5"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost@1.85" # Boost 1.87+ issue: https://github.com/pavel-odintsov/fastnetmon/issues/1027
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

  # Fix build failure with gRPC 1.67.
  # https://github.com/pavel-odintsov/fastnetmon/pull/1023
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/b6cf2e7222c24343b868986e867ddb7adad0bf30.patch?full_index=1"
    sha256 "3a3f719f7434e52db01a512ed3891cf0e3794d4576323e3c2fd3b31c69fb39be"
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
    inreplace "fastnetmon.conf", %r{/tmp/(fastnetmon(?:_ipv6)?\.dat)}, "#{testpath}/\\1"

    pid = spawn opt_sbin/"fastnetmon", "--configuration_file", testpath/"fastnetmon.conf", "--log_to_console"
    sleep 60
    sleep 30 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end
