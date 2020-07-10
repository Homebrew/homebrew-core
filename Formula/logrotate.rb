class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.17.0/logrotate-3.17.0.tar.xz"
  sha256 "58cc2178ff57faa3c0490181cce041345aeca6cff18dba1c5cd1398bf1c19294"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "685db75f3f5c08510db50a7966f2b8d4028709cd02fd586ed21b17e978fd5446" => :catalina
    sha256 "f32319879033d83978b6dbd4dc970880e733ae437df2de5954c3ca2a6708c850" => :mojave
    sha256 "38b4e975405eb2a32b7a0d1c8904846198364036deaec47393e6475dc340ca7b" => :high_sierra
  end

  depends_on "popt"

  # https://github.com/logrotate/logrotate/pull/344
  patch do
    url "https://github.com/logrotate/logrotate/commit/5aee3d4d73bbdca7531bf641a78bcb5ec58d93ea.diff?full_index=1"
    sha256 "1fd0057b7b97cd5070a5bacacdfd5c2bc4f68c86dcd438b6efd76cdbab86710c"
  end

  def install
    system "./configure", "--disable-dependency-tracking",
                          "--prefix=#{prefix}",
                          "--with-compress-command=/usr/bin/gzip",
                          "--with-uncompress-command=/usr/bin/gunzip",
                          "--with-state-file-path=#{var}/lib/logrotate.status"
    system "make", "install"

    inreplace "examples/logrotate.conf", "/etc/logrotate.d", "#{etc}/logrotate.d"
    etc.install "examples/logrotate.conf" => "logrotate.conf"
    (etc/"logrotate.d").mkpath
  end

  plist_options :manual => "logrotate"

  def plist
    <<~EOS
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
    (testpath/"testlogrotate.conf").write <<~EOS
      #{testpath}/test.log {
        size 1
        copytruncate
      }
    EOS
    system "#{sbin}/logrotate", "-s", "logstatus", "testlogrotate.conf"
    assert(File.size?("test.log").nil?, "File is not zero length!")
  end
end
