class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.8.tar.gz"
  sha256 "d16901b00963f395241c818d02ad2751f14e33fd32ed3cb3011641ab680e0d01"
  license "GPL-2.0-only"
  revision 28

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "9ddf7485701a4fea3c2465ea31394b424fca7e3d01c81e48fd31b4d332517a49"
    sha256 cellar: :any, arm64_sequoia: "f7efca35a133c0722b19ae7de90e1431edd4bcb51830469751957e4b6f9ba004"
    sha256 cellar: :any, arm64_sonoma:  "2b3cb83a8e8ce55171faa764538afbcae5accbe7f5768180e4f6fd900f26d5df"
    sha256 cellar: :any, sonoma:        "a6fd83d0825ecea60c04a0ca92bc3eb1b63e1ad0f3fa59744fc93dc2c36296eb"
    sha256               arm64_linux:   "1e4b1a177b2c7ce6fa39a5c562695c3a0e43bccaa3acb3606a6f8f3108284370"
    sha256               x86_64_linux:  "f28268984eb355b891f46977e170639c07e9b5c25dbba711f4cb1e8658cac9a3"
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

  # Backport support for mongo-c-driver 2
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/187ef0c9d0fd7f86f24c70b5233635eecc5943cf.patch?full_index=1"
    sha256 "30517a7eb3a07ad1aa324a6f6a31adc8d1ff936fb7ef1d0459efd1190432da65"
  end
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/1ef41391c7d816e9d6105271b847c68593cb4a1c.patch?full_index=1"
    sha256 "e0e74b52906c3fb91ea0627a3d72d95ae6f2008ac14f969e609a754321015218"
  end
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/943d8707cea1622aa20837a232a429277acdd0a7.patch?full_index=1"
    sha256 "5312098a590d95adf30acfee38a777de0f80d3efc7a07ea1fe68fd7eb03247a7"
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
