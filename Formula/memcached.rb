class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.22.tar.gz"
  sha256 "c2b47e9d20575a2367087c229636ffc3fb699a6c3a7f3a22f44402f25f5f1f93"
  head "https://github.com/memcached/memcached.git"

  bottle do
    cellar :any
    sha256 "e51087b5f555e07edfaec6ea6c7d6f9391cc3e7db70c9a2c0d94c7b1a20ebb51" => :catalina
    sha256 "f74f56c7e1e8c358694a0cb4842d4c8e002a4bc7c7249b4cea64997195c0a781" => :mojave
    sha256 "851b26d026604f265cb237f53aaa3d47fde7ceaad564c9eb3ab6b946897a0c9f" => :high_sierra
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
