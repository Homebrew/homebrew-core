class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.13.0/logrotate-3.13.0.tar.gz"
  sha256 "2ea33f69176dd2668fb85307210d7ed0411ff2a0429e4a0a2d881e740160e4b0"

  bottle do
    sha256 "e1f19be946b643cdac9c24bf6085a4130e6cd5224355059b2a1b6a3c95094c28" => :high_sierra
    sha256 "c05cad8c62e0121cf9f7c65cda3f1bad72793af7e31b51dc45c84ade68121615" => :sierra
    sha256 "220fec6f092f5878158b8028f13c4184a41145faa9b681da7288fa42d87e4e20" => :el_capitan
  end

  depends_on "popt"

  # Adapt the default config for Homebrew
  patch :DATA

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status"
    system "make", "install"

    inreplace "examples/logrotate-default", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate-default" => "logrotate.conf"
    (etc/"logrotate.d").mkpath
  end

  plist_options :manual => "logrotate"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{sbin}/logrotate</string>
          <string>#{etc}/logrotate.conf</string>
        </array>
        <key>RunAtLoad</key>
        <false/>
        <key>StartCalendarInterval</key>
        <dict>
          <key>Hour</key>
          <integer>6</integer>
          <key>Minute</key>
          <integer>25</integer>
        </dict>
      </dict>
    </plist>
    EOS
  end

  test do
    (testpath/"test.log").write("testlograndomstring")
    (testpath/"testlogrotate.conf").write <<-EOS.undent
        #{testpath}/test.log {
        size 1
        copytruncate
    }
    EOS
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end

__END__
diff --git i/examples/logrotate-default w/examples/logrotate-default
index 39a092d..c61a33a 100644
--- i/examples/logrotate-default
+++ w/examples/logrotate-default
@@ -14,23 +14,7 @@ dateext
 # uncomment this if you want your log files compressed
 #compress

-# RPM packages drop log rotation information into this directory
+# Homebrew packages drop log rotation information into this directory
 include /etc/logrotate.d

-# no packages own wtmp and btmp -- we'll rotate them here
-/var/log/wtmp {
-    missingok
-    monthly
-    create 0664 root utmp
-    minsize 1M
-    rotate 1
-}
-
-/var/log/btmp {
-    missingok
-    monthly
-    create 0600 root utmp
-    rotate 1
-}
-
 # system-specific logs may be also be configured here.
