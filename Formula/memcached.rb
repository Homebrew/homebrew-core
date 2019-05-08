class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.13.tar.gz"
  sha256 "61e1a774949735a9eb6e40992bb04083d8427f3d0ce1a52a15c0116db39c4d63"

  bottle do
    cellar :any
    sha256 "fc4583c8fa81ecf0163288f14704eaa6d3f051dadeecba2c408182435471effd" => :mojave
    sha256 "a5288b4ce653000e8207f0cea83845feb479194d4848a092254355d95ec51ba5" => :high_sierra
    sha256 "ed91eba819e3654983cf6c40cfa8a87ad9dae9ffe28a319d425ae822a83a21ca" => :sierra
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
