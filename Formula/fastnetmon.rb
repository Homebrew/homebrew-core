class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "72f364ff5557afe5670bb9444e975841bf2c2db4eb13d2425e5d2903ca8fcf22"
  license "GPL-2.0-only"
  revision 2

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_ventura:  "2b4dda6d3c0f218d666e88f459dda479b322e26374c9f9dde86bdae5b1660ce2"
    sha256 cellar: :any,                 arm64_monterey: "00ecd8349b21c859ea3c1cf175eaf7088272c1c881f913aeff436f1c63596104"
    sha256 cellar: :any,                 arm64_big_sur:  "28e6a96d656dcfa6bc44da3c7a3dc95ad8d8bbeb7de07fea39010795ddd88b29"
    sha256 cellar: :any,                 ventura:        "d4eae16a2d4ed1d01ccaa32e44eb8f9a352686a2a5e8edd9b8f6c49dc0e7f064"
    sha256 cellar: :any,                 monterey:       "683804fc1a036bc97e1613783f031db86d6e8818ef9754b4eda54a9fec413f3c"
    sha256 cellar: :any,                 big_sur:        "82f8d91c8f71cbf25c183bd5a5f6ddb6004272ebe65e4ac68611be942ab59c7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "27777837bc3236e5abd9f799307aa3c09d5900c14b9e70c4d948ac48c01101b6"
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

    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/c48497a6f109fc1a9f5da596b055c3b7cffb96d4.patch?full_index=1"
      sha256 "2e3eabf7727e12d2f1d57f1db84d1272468abd67989cc8d9a8624035c36aa8c8"
    end
    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/c718e88d0b25dcfbd724e9820f592fd5782eca6c.patch?full_index=1"
      sha256 "bd7e7e1de406b0918a192dcc8a058e82bee4195c3f00157902f0c998f9b3d0e2"
    end
    patch do
      url "https://github.com/pavel-odintsov/fastnetmon/commit/3b912332801c85dd5840cedb6bb248a339056187.patch?full_index=1"
      sha256 "bbdbfed272efcd05959479636857c89721379ec5585f5e5ff8a1523e1b32ee1d"
    end
  end

  fails_with gcc: "5"

  # patch macOS build, remove in next release
  # upstream PR ref, https://github.com/pavel-odintsov/fastnetmon/pull/950
  patch do
    url "https://github.com/pavel-odintsov/fastnetmon/commit/b3895208c9aab27881c97e1181e7622ea3ea84b0.patch?full_index=1"
    sha256 "8ee473b8b44765af6ad5bb9e9ffec7cb6b47bec196fb96de12f21bf890f778a1"
  end

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
