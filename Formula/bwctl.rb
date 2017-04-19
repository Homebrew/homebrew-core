class Bwctl < Formula
  desc "Command-line tool and daemon for network measuring tools"
  homepage "https://software.internet2.edu/bwctl/"
  url "https://software.internet2.edu/sources/bwctl/bwctl-1.5.4.tar.gz"
  sha256 "e6dca6ca30c8ef4d68e6b34b011a9ff7eff3aba4a84efc19d96e3675182e40ef"

  bottle do
    cellar :any_skip_relocation
    sha256 "23f32c2e2b5203c4b4fecfb33e2152e5d732305e60ef5b02e4bbf1a9f7355c73" => :sierra
    sha256 "ac9e615919ebd84515022f9650f42194d9ad4b1c1f5f97509e1293962a96e943" => :el_capitan
    sha256 "c8890647536e60b3ed8599eb3239ee59fde0382e9df8b7585ee7eeb20275fc39" => :yosemite
    sha256 "f10efbf8f41f526130340cc6087ce3dfad83b71b69d21e0b01c11b3169d88bdd" => :mavericks
    sha256 "b60c679e8b498ffc23e697cb025dc6decc4f4d939e2b0874ff36291967eee18d" => :mountain_lion
  end

  depends_on "i2util" => :build
  depends_on "iperf3" => :optional
  depends_on "thrulay" => :optional

  # Fix to allow bwctl -Z to start under launchd.
  # https://github.com/perfsonar/bwctl/pull/36
  patch :DATA

  def install
    # configure mis-sets CFLAGS for I2util
    # https://lists.internet2.edu/sympa/arc/perfsonar-user/2015-04/msg00016.html
    # https://github.com/Homebrew/homebrew/pull/38212
    inreplace "configure", 'CFLAGS="-I$I2util_dir/include $CFLAGS"', 'CFLAGS="-I$with_I2util/include $CFLAGS"'

    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}",
                          "--with-I2util=#{Formula["i2util"].opt_prefix}"
    system "make", "install"

    (buildpath+"bwctld.conf").write bwctld_conf
    (buildpath+"bwctld.keys").write ""
    (buildpath+"bwctld.limits").write bwctld_limits
    etc.install "bwctld.conf"
    etc.install "bwctld.keys"
    etc.install "bwctld.limits"

    (var+"log/bwctl").mkpath
    (var+"run").mkpath
  end

  def bwctld_conf; <<-EOS.undent
    allow_unsync
    log_location
    peer_port       6001-6200
    facility        local5
    test_port       5001-5900
    iperf_port      5001-5300
    nuttcp_port     5301-5600
    owamp_port      5601-5900
    user            nobody
    group           nobody
    EOS
  end

  def bwctld_limits; <<-EOS.undent
    limit root with allow_udp=on, bandwidth=900000000, max_time_error=20, allow_tcp=on, allow_open_mode=on, duration=60
    limit regular with allow_udp=off, parent=root
    limit jail with allow_udp=off, bandwidth=1, parent=root, allow_tcp=off, allow_open_mode=off, duration=1
    assign net ::1/128 root
    assign net 127.0.0.1/32 root
    assign net 172.16.10.0/24 jail
    assign default regular
    EOS
  end

  plist_options :startup => true,
                :manual => "bwctld -c #{HOMEBREW_PREFIX}/etc -R #{HOMEBREW_PREFIX}/var/run"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/bwctld</string>
        <string>-c</string>
        <string>#{etc}</string>
        <string>-R</string>
        <string>#{var}/run</string>
        <string>-Z</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>KeepAlive</key>
      <true/>
      <key>EnvironmentVariables</key>
      <dict>
        <!-- Needs to be able to find iperf and iperf3 binaries -->
        <key>PATH</key>
        <string>/usr/local/bin:/usr/local/sbin:/usr/bin:/bin:/usr/sbin:/sbin</string>
      </dict>
      <key>WorkingDirectory</key>
      <string>#{var}/log/bwctl</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/bwctl/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/bwctl/output.log</string>
      <key>HardResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
      <key>SoftResourceLimits</key>
      <dict>
        <key>NumberOfFiles</key>
        <integer>1024</integer>
      </dict>
    </dict>
    </plist>
    EOS
  end

  test do
    system "#{bin}/bwctl", "-V"
  end
end
__END__
--- a/bwctld/bwctld.c
+++ b/bwctld/bwctld.c
@@ -2566,7 +2566,7 @@ main(int argc, char *argv[])
          * kill call.) setsid handles this when daemonizing.
          */
         mypid = getpid();
-        if(setpgid(0,mypid) != 0){
+        if(getsid(0) != mypid && setpgid(0,mypid) != 0){
             I2ErrLog(errhand,"setpgid(): %M");
             exit(1);
         }
