class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.21.tar.gz"
  sha256 "e3d10c06db755b220f43d26d3b68d15ebf737a69c7663529b504ab047efe92f4"
  head "https://github.com/memcached/memcached.git"

  bottle do
    cellar :any
    rebuild 1
    sha256 "a03608101a7aa55a32ef05d945e852bfc22cbd4647c5a6d41d7957c022489e02" => :catalina
    sha256 "cca9f385ec7477a12f787aec8cb0da8a58f83c170e8ded061cbbdff75e158ccf" => :mojave
    sha256 "893bc856ebe459590a08c6acf9ad863d850413de804ddac8b65d1262c5dc2467" => :high_sierra
  end

  depends_on "libevent"

  # fix for https://github.com/memcached/memcached/issues/598, included in next version
  patch do
    url "https://github.com/memcached/memcached/commit/7e3a2991.diff?full_index=1"
    sha256 "063a2d91f863c4c6139ff5f0355bd880aca89b6da813515e0f0d11d9295189b4"
  end

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
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
