class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.1.tar.gz"
  sha256 "881c30a222e019657e53b12230aaf629d7b5c080e4b74378c2eb5e78800d57d6"
  head "https://github.com/memcached/memcached.git"

  bottle do
    cellar :any
    sha256 "f24a1cc41a029a1f021ae4913ed4920d012afa61aa05495347cea1cfd76f63e0" => :catalina
    sha256 "562e49ae712a7adb81d2600a166d7ad2e4968f0914c30e9af76f4fd84cf72d16" => :mojave
    sha256 "9d27ad1dd49348f0607117fcc6f0c3b50f042f5947e4e8362dcbe59a1d6a571e" => :high_sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options :manual => "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

  def plist
    <<~EOS
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
