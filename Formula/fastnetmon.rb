class Fastnetmon < Formula
  desc "DDoS detection tool with sFlow, Netflow, IPFIX and port mirror support"
  homepage "https://github.com/pavel-odintsov/fastnetmon/"
  url "https://github.com/pavel-odintsov/fastnetmon/archive/refs/tags/v1.2.3.tar.gz"
  sha256 "72f364ff5557afe5670bb9444e975841bf2c2db4eb13d2425e5d2903ca8fcf22"
  license "GPL-2.0-only"
  revision 1

  bottle do
    sha256 cellar: :any,                 arm64_ventura:  "0b288a48afbb57ee5bc4594278228ed4c05384f76565e66f666a90ef97c4661f"
    sha256 cellar: :any,                 arm64_monterey: "d5b0f4ad6d5e5720c245289927fcf61728a3a98e276ab847babadf8dbae5be3f"
    sha256 cellar: :any,                 arm64_big_sur:  "9425630b68df30662fbea586bcecf1032916839f6358d14efddc4749faede471"
    sha256 cellar: :any,                 ventura:        "33ffa965225ad50ea02c3dfdd59de401efeec6f28c0ed45d8a17c2c0099c07b3"
    sha256 cellar: :any,                 monterey:       "ef602f5be49d0f0b0a3dcc64921722cf77226aebb057929dbf7c4891ca4f69be"
    sha256 cellar: :any,                 big_sur:        "9b656b4517c983bec8e5d61e19c7cf14087a00c23069ea0f0a71103e63cd3769"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d522a002ffc40b83e3a478f66421c666b3cb3da56d4bc1b75cc63603febc827f"
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
