class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  license "MIT"
  revision 4

  stable do
    url "https://collectd.org/files/collectd-5.12.0.tar.bz2"
    sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"

    # Fix -flat_namespace being used on Big Sur and later.
    patch do
      url "https://raw.githubusercontent.com/Homebrew/formula-patches/03cf8088210822aa2c1ab544ed58ea04c897d9c4/libtool/configure-big_sur.diff"
      sha256 "35acd6aebc19843f1a2b3a63e880baceb0f5278ab1ace661e57a502d9d78c93c"
    end
  end

  livecheck do
    url "https://collectd.org/download.shtml"
    regex(/href=.*?collectd[._-]v?(\d+(?:\.\d+)+)\.t/i)
  end

  bottle do
    sha256 arm64_monterey: "6c97b6dd842eef1039274fe486610a7bed962641287616c090e8efee2988a152"
    sha256 arm64_big_sur:  "7a332bc097937b5c37c03045bf6057899864060f9745c4cd1a9f7bd29a1966cc"
    sha256 monterey:       "065dd7bca160e56183ab001c3a7633cfbc6c5f9aeef180c2eceb065462b754d5"
    sha256 big_sur:        "67299ad233174c4d96e60e10dc3438e72dab207b8e8701f34cf4a6e74006e353"
    sha256 catalina:       "91b56cd33546d352a4e6076172f2ea348df39333f2249894cac5f4e4cca004d3"
    sha256 x86_64_linux:   "103d8daf840e57089e92ac68e6f2349794f845080431f0691639305803e47b03"
  end

  head do
    url "https://github.com/collectd/collectd.git", branch: "main"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"

  uses_from_macos "bison" => :build
  uses_from_macos "flex" => :build
  uses_from_macos "perl"

  def install
    args = std_configure_args + %W[
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]
    args << "--with-perl-bindings=PREFIX=#{prefix} INSTALLSITEMAN3DIR=#{man3}" if OS.linux?

    system "./build.sh" if build.head?
    system "./configure", *args
    system "make", "install"
  end

  service do
    run [opt_sbin/"collectd", "-f", "-C", etc/"collectd.conf"]
    keep_alive true
    error_log_path var/"log/collectd.log"
    log_path var/"log/collectd.log"
  end

  test do
    log = testpath/"collectd.log"
    (testpath/"collectd.conf").write <<~EOS
      LoadPlugin logfile
      <Plugin logfile>
        File "#{log}"
      </Plugin>
      LoadPlugin memory
    EOS
    begin
      pid = fork { exec sbin/"collectd", "-f", "-C", "collectd.conf" }
      sleep 1
      assert_predicate log, :exist?, "Failed to create log file"
      assert_match "plugin \"memory\" successfully loaded.", log.read
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
