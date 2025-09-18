class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "d16901b00963f395241c818d02ad2751f14e33fd32ed3cb3011641ab680e0d01"
  license "GPL-2.0-only"
  revision 15

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "29abfa0b9dbbd0f52909a78c5b2339d4a7be0c68781b535580e533318025ce92"
    sha256 cellar: :any, arm64_sequoia: "47d1cb7734a0ec85afbf8422e750b51afe0668865532fde1d784892425a264fe"
    sha256 cellar: :any, arm64_sonoma:  "b0d0b6576cd0df87fb976c422d6efe890522a41a6d9f31c41ef8e87ab9ec3137"
    sha256 cellar: :any, sonoma:        "dc16093423817326432cd26fe2eed0ed4dfdd534baf6c36875a52c47404ed5d7"
    sha256               arm64_linux:   "010f77b6fbc003492320f6f51986661d30419546a8c2d20b7811e560ec762485"
    sha256               x86_64_linux:  "442e110a1a82ab9b14f95ddcb0343e66f86f01ef3f68bee8a8f3cac6eeec7131"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver@1"
  depends_on "openssl@3"
  depends_on "protobuf"

  uses_from_macos "libpcap"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "elfutils"
    depends_on "libbpf"
  end

  # Backport support for Boost 1.87.0
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/f02063204d2b07a525d70e502571b31514653604.patch?full_index=1"
    sha256 "273d22bdfae85e464ab8cc1044423b2589800bef1db649f664049030f2cf719b"
  end

  # Backport fix to build with Clang
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/8a91b5a8c8be1af0fe96ffe1ee1c002c30494662.patch?full_index=1"
    sha256 "cb2dd41177c73ed3ef4ee3a372d8f99b6471f695041dc1c05299ea03a572a202"
  end

  # Fix build with Boost 1.89.0, pr ref: https://github.com/pavel-odintsov/fastnetmon/pull/1038
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/4a526e90d5b493265ca2e7ffcbcdbb6ed10f064b.patch?full_index=1"
    sha256 "d879800c448a08cbe312ca5c83edfaacffadb0a74f57707240a31316275abc6d"
  end

  def install
    system "cmake", "-S", "src", "-B", "build",
                    "-DCMAKE_CXX_STANDARD=20",
                    "-DLINK_WITH_ABSL=ON",
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
    sleep 40 if OS.mac? && Hardware::CPU.intel?

    assert_path_exists testpath/"fastnetmon.dat"
    assert_path_exists testpath/"fastnetmon_ipv6.dat"
    assert_match "Incoming traffic", (testpath/"fastnetmon.dat").read
    assert_match "Incoming traffic", (testpath/"fastnetmon_ipv6.dat").read
  ensure
    Process.kill "SIGTERM", pid
  end
end
