class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.18.0/logrotate-3.18.0.tar.xz"
  sha256 "841f81bf09d0014e4a2e11af166bb33fcd8429cc0c2d4a7d3d9ceb3858cfccc5"
  license "GPL-2.0"

  bottle do
    cellar :any
    sha256 "8074cf8252a19b7be06a4600ab49b38c16b6ac884ca58744c1afc489cc04eac9" => :big_sur
    sha256 "4302035ee1c9162e650852b38ad0b384cb3ad2f7e74a97ff72f57e2d50d5848e" => :arm64_big_sur
    sha256 "a8a48494c6d57c20ac9ff7b38d0ca2ed41ec16640928f0f4c83bfb18ea744908" => :catalina
    sha256 "c970d6bce04d119e0ba69d925b5230d61fa71b92d51792744d9590a9cb8ead18" => :mojave
  end

  depends_on "popt"

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

  plist_options manual: "logrotate"

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
