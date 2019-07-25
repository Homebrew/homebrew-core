class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.16.tar.gz"
  sha256 "45a22c890dc1edb27db567fb4c9c25b91bfd578477c08c5fb10dca93cc62cc5a"

  bottle do
    cellar :any
    sha256 "ad92429279c21a55ebf3c3715d1ffd051fae10fb171f38d68b9d9829a1ecb4da" => :mojave
    sha256 "8e523a5bab95585ebcb29bcdbe4ce3aeff11ad80b5c286bef8e81454a65ee6d3" => :high_sierra
    sha256 "7e8473396ca5431a2ff6d0360728d667b02d1be8e9e5c11d47e79bc14453a223" => :sierra
  end

  depends_on "libevent"

  conflicts_with "mysql-cluster", :because => "both install `bin/memcached`"

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
