class Collectd < Formula
  desc "Statistics collection and monitoring daemon"
  homepage "https://collectd.org/"
  url "https://collectd.org/files/collectd-5.12.0.tar.bz2"
  sha256 "5bae043042c19c31f77eb8464e56a01a5454e0b39fa07cf7ad0f1bfc9c3a09d6"
  license "MIT"
  revision 1

  bottle do
    sha256 arm64_big_sur: "c0a9e32a3407d094ae4fe5f8bf0fc19d0b4f5f0bb40f8ce6335fe4d2241a72b3"
    sha256 big_sur:       "73233ee8e731722660a1098db2a72ae276508b8b09475f101f50a8d5ddc49251"
    sha256 catalina:      "33f0fa042a98883dbf363865a66d64fd53e2eaebc330829257e2d5c87c7b5a4d"
    sha256 mojave:        "a38f5912b4ed2b48e37e7285e0dd6e4f97d31799e5e7c47f438cddd7806a1252"
    sha256 x86_64_linux:  "9b7b93198f1b6008763a8012fa7209c108b5e179a0b38da1599234b6fe06523a"
  end

  head do
    url "https://github.com/collectd/collectd.git"

    depends_on "autoconf" => :build
    depends_on "automake" => :build
  end

  depends_on "pkg-config" => :build
  depends_on "libgcrypt"
  depends_on "libtool"
  depends_on "net-snmp"
  depends_on "riemann-client"

  uses_from_macos "bison"
  uses_from_macos "flex"
  uses_from_macos "perl"

  def install
    args = %W[
      --disable-debug
      --disable-dependency-tracking
      --prefix=#{prefix}
      --localstatedir=#{var}
      --disable-java
      --enable-write_riemann
    ]

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
