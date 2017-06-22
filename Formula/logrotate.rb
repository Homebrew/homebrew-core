class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.12.2/logrotate-3.12.2.tar.gz"
  sha256 "754777ada2ef2f34378e8f6025cdb0c0725e212f12195d59971c42df0ae0597f"

  bottle do
    sha256 "9d80ac390902aa814b54a6b867af6f9bda867a61d2273eb1f5a1075c2d2a78dc" => :sierra
    sha256 "89e9dd258e1169afb9dc8b73c468730e15dc65f1bf35f46beb197fc1765ef2da" => :el_capitan
    sha256 "96acb7bb80d18c06d793a271332813155fb09b983f69af2a36acfe9939ff7c8d" => :yosemite
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
index 56e9103..c61a33a 100644
--- i/examples/logrotate-default
+++ w/examples/logrotate-default
@@ -14,22 +14,7 @@ dateext
 # uncomment this if you want your log files compressed
 #compress
 
-# RPM packages drop log rotation information into this directory
+# Homebrew packages drop log rotation information into this directory
 include /etc/logrotate.d
 
-# no packages own wtmp and btmp -- we'll rotate them here
-/var/log/wtmp {
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
