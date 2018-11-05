class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.12.tar.gz"
  sha256 "c02f97d5685617b209fbe25f3464317b234d765b427d254c2413410a5c095b29"

  bottle do
    cellar :any
    rebuild 1
    sha256 "71a70604b37e8f04e679f047bed880e5770784b82534fec4c5f7ca0a6a1faa37" => :mojave
    sha256 "3ff496d09e336ab5c380c661704c24e93308a2f0032b8fdbdad54beaac1884cd" => :high_sierra
    sha256 "7b5c416abb2a82db447d0c46bb400da40d6a9a1540bbb70f9a1437dccb9fd205" => :sierra
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
