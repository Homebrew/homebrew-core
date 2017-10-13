class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.13.0/logrotate-3.13.0.tar.gz"
  sha256 "2ea33f69176dd2668fb85307210d7ed0411ff2a0429e4a0a2d881e740160e4b0"

  bottle do
    sha256 "b8f261bc65fc43cdffd6db04842e856089d1fac34e69a3d617ef750ea8d5e543" => :high_sierra
    sha256 "c71cc8692bdd28fcf4ba25002d1177a9f60e3c68cbe1fecc46d16a1cb56ec58f" => :sierra
    sha256 "809a917ade7e1e83bfd871f87be42a9001d0b082190e2ea5ca77c8b840598c0c" => :el_capitan
    sha256 "d7bbd4bdbe2de2730ee27c92fc215e7d6fecb0c1ff0daa3baecb46f904b8a10d" => :yosemite
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
