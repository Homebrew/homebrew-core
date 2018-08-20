class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.14.0/logrotate-3.14.0.tar.gz"
  sha256 "9bb62355ecf26997d994498658781a40fcd117b3e9d2872362db504b98df5c47"

  bottle do
    sha256 "f9635a875c53e1ccfda813a788aa9bdd0c85c0dd3b73b940be468bc375ed14cb" => :mojave
    sha256 "fb7c69ba0723255b69a48402deacc16ba6395ff69bd258f709c412cee4b70dc9" => :high_sierra
    sha256 "d295638d3dd9bb6cadaaaa84afda9a2542d529e83727f944ffddb4d8683c3ccf" => :sierra
    sha256 "c53babb6bca4886b76933bee0c55efac35ed23352af83b8755975e79b1d94cd8" => :el_capitan
  end

  depends_on "popt"

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

  def plist; <<~EOS
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
