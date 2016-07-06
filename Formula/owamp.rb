class Owamp < Formula
  desc "Implementation of the One-Way Active Measurement Protocol"
  homepage "https://www.internet2.edu/products-services/performance-analytics/performance-tools/"
  url "http://software.internet2.edu/sources/owamp/owamp-3.4-10.tar.gz"
  sha256 "059f0ab99b2b3d4addde91a68e6e3641c85ce3ae43b85fe9435841d950ee2fb3"

  bottle do
    cellar :any_skip_relocation
    revision 1
    sha256 "6f86a33c176ba1394560b7707466c088930f13db102b7adc159e80e889fdc5cf" => :el_capitan
    sha256 "fce4cc5bf0a9b5355779fb45637651f6a78bb8d3dd93bdc3ff2826b7866617fd" => :yosemite
    sha256 "6c6b6f1f143b929b892c6556db3b06299835326a72c5180c482b2630e62dc543" => :mavericks
  end

  depends_on "i2util"

  # Fix to prevent tests hanging under certain circumstances.
  # Provided by Aaron Brown via perfsonar-user mailing list:
  # https://lists.internet2.edu/sympa/arc/perfsonar-user/2014-11/msg00131.html
  # Also fix to allow owampd -Z to start under launchd.
  # https://github.com/perfsonar/owamp/pull/11
  patch :DATA

  def install
    system "./configure", "--disable-debug",
                          "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--mandir=#{man}"
    system "make", "install"

    (buildpath+"owampd.conf").write owampd_conf
    (buildpath+"owampd.limits").write owampd_limits
    etc.install "owampd.conf"
    etc.install "owampd.limits"

    (var+"lib/owamp").mkpath
    (var+"log/owamp").mkpath
    # FIXME: daemon fails with
    # Jul  6 14:24:44 bri12-client-1networkcityfibrecom.local owampd[6830] <Error>: FILE=policy.c, LINE=811, Unable to mkdir(/usr/local/var/lib/owamp/catalog): Permission denied
    # until you do: chown nobody:nogroup /usr/local/var/lib/owamp
    (var+"run").mkpath
  end

  def owampd_conf; <<-EOS.undent
    user      nobody
    group     nobody
    verbose
    facility  local5
    loglocation
    vardir    #{var}/run
    datadir   #{var}/lib/owamp
    testports 8760-9960
    diskfudge 3.0
    EOS
  end

  def owampd_limits; <<-EOS.undent
    limit root with delete_on_fetch=on, bandwidth=0, disk=0, allow_open_mode=on
    limit regular with delete_on_fetch=on, parent=root, bandwidth=10M, disk=1G, allow_open_mode=on
    limit jail with parent=root, bandwidth=1, disk=1, allow_open_mode=off
    assign default regular
    EOS
  end

  plist_options :startup => true,
                :manual => "owampd -c #{HOMEBREW_PREFIX}/etc -R #{HOMEBREW_PREFIX}/var/run"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/owampd</string>
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
      <key>WorkingDirectory</key>
      <string>#{var}/log/owamp</string>
      <key>StandardErrorPath</key>
      <string>#{var}/log/owamp/output.log</string>
      <key>StandardOutPath</key>
      <string>#{var}/log/owamp/output.log</string>
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
    system "#{bin}/owping", "-h"
  end
end

__END__
diff -ur owamp-3.4/owamp/endpoint.c owamp-3.4.fixed/owamp/endpoint.c
--- owamp-3.4/owamp/endpoint.c	2014-03-21 09:37:42.000000000 -0400
+++ owamp-3.4.fixed/owamp/endpoint.c	2014-11-26 07:50:11.000000000 -0500
@@ -2188,6 +2188,11 @@
         timespecsub((struct timespec*)&wake.it_value,&currtime);

         wake.it_value.tv_usec /= 1000;        /* convert nsec to usec        */
+        while (wake.it_value.tv_usec >= 1000000) {
+            wake.it_value.tv_usec -= 1000000;
+            wake.it_value.tv_sec++;
+        }
+
         tvalclear(&wake.it_interval);

         /*
--- a/owampd/owampd.c
+++ b/owampd/owampd.c
@@ -1673,7 +1673,7 @@ int main(
          * kill call.) setsid handles this when daemonizing.
          */
         mypid = getpid();
-        if(setpgid(0,mypid) != 0){
+        if(getsid(0) != mypid && setpgid(0,mypid) != 0){
             I2ErrLog(errhand,"setpgid(): %M");
             exit(1);
         }
