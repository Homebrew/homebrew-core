class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "72f364ff5557afe5670bb9444e975841bf2c2db4eb13d2425e5d2903ca8fcf22"
  license "GPL-2.0-only"
  revision 2

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "4af807a58397ac1aaeb66ddf6a40370bdea2c263b564679ce8cf26a6cec15468"
    sha256 cellar: :any,                 arm64_monterey: "dad57f07e2b09065646fe5ba4a95a6f3ca5b1942aeb6ce20fddd1ff295c5d1ad"
    sha256 cellar: :any,                 arm64_big_sur:  "4bf8c6fede0588f485743747bca66426987785586541da2716081bc4bef9dfd0"
    sha256 cellar: :any,                 ventura:        "d09403e88899dc70f290887f66390e046e37d4800eb015332cde3d4530c955f7"
    sha256 cellar: :any,                 monterey:       "49eab6198e74cd00c5ea0994076000d4099348f676fbfd3cac10f39a551b377c"
    sha256 cellar: :any,                 big_sur:        "9257546d16889bf24a33b06d67963c4d4eec6a9ea119fd49a5e35ba50c19370c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f9e80cc2b916e701a1048afd79d5b7420dc9a79be660a6f101a3e25f9e84abdc"
  end

  depends_on "cmake" => :build
  depends_on "abseil"
  depends_on "boost"
  depends_on "capnp"
  depends_on "grpc"
  depends_on "hiredis"
  depends_on "json-c"
  depends_on "log4cpp"
  depends_on macos: :big_sur # We need C++ 20 available for build which is available from Big Sur
  depends_on "mongo-c-driver"
  depends_on "openssl@1.1"
  uses_from_macos "ncurses"

  on_linux do
    depends_on "libbpf"
    depends_on "libelf"
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
    url "https://github.com/pavel-odintsov/fastnetmon/commit/94d88b6bdfd438eaeac63f39441d4fc7e2bd76f0.patch?full_index=1"
    sha256 "0b70fd1a9e47f2f1de3580564089e355905a89f5a05bfecd6d10f5b29a7d569a"
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
