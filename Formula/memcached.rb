class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.18.tar.gz"
  sha256 "9ebdd6705b06da70eb6f68245686554b1cb689f00b9bff6e33672c1a0125ef88"

  bottle do
    cellar :any
    sha256 "c99a8d1336fe3838697dbe1abdc69042cbdb5b8cc1020c3af0809aec2cbf8115" => :catalina
    sha256 "43fd0bc7a774b4d9b3ab647446c41edb0c9ec2bfb9181b08fde6708b1472bce2" => :mojave
    sha256 "b0dca520878765e47cfca96664cab64082a12d9b9ccd67d3e590791ee4930eef" => :high_sierra
    sha256 "ae191a0130c15f45926a9b766f234b02457fa7d6a027a06cc15eb068085914b4" => :sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage"
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist; <<~EOS
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
    <dict>
      <key>Label</key>
      <string>#{plist_name}</string>
      <key>KeepAlive</key>
      <true/>
      <key>ProgramArguments</key>
      <array>
        <string>#{opt_bin}/memcached</string>
        <string>-l</string>
        <string>localhost</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
      <key>WorkingDirectory</key>
      <string>#{HOMEBREW_PREFIX}</string>
    </dict>
    </plist>
  EOS
  end

  test do
    pidfile = testpath/"memcached.pid"
    # Assumes port 11211 is not already taken
    system bin/"memcached", "--listen=localhost:11211", "--daemon", "--pidfile=#{pidfile}"
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
