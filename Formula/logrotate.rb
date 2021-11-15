class Logrotate < Formula
  desc "Rotates, compresses, and mails system logs"
  homepage "https://github.com/logrotate/logrotate"
  url "https://github.com/logrotate/logrotate/releases/download/3.18.1/logrotate-3.18.1.tar.xz"
  sha256 "14a924e4804b3974e85019a9f9352c2a69726702e6656155c48bcdeace68a5dc"
  license "GPL-2.0"

  bottle do
    sha256 cellar: :any,                 arm64_monterey: "e02202d8879a0df397d38756657da92460d9574f0a5f7d222e704daba047d513"
    sha256 cellar: :any,                 arm64_big_sur:  "7a35f391118adf13094e83d7ab66a0a0842828b6d17bb825a04a2c15ff0cb8b5"
    sha256 cellar: :any,                 monterey:       "a177d5de09fd91c9cd28edd2ea568514a24a6e09dbcd17910233e4b44847ecbf"
    sha256 cellar: :any,                 big_sur:        "6976c5e710c45560e47c8eaba409aaf71e607cec3e86eaa6396df5342685b720"
    sha256 cellar: :any,                 catalina:       "82980e80bdd29e8b5d21661e5ffd283c654057912fb0d8621e30397f577dc1e4"
    sha256 cellar: :any,                 mojave:         "2aeb1ee2d25cb426a1d7a746c54451afad0d5f00a24c6cf6f38eb5be2a0c4e5a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b450a79764d5a0bb3e4cfddf3bc337bb703c34386254b76dbcd45fd09ae72ab7"
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
