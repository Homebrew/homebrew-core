class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.17.tar.gz"
  sha256 "ac7c5af6e8b1acf5d5c644d162e046d8acf9302174af9f24c3f18e5481ce3a0d"

  bottle do
    cellar :any
    sha256 "bd5a5f2d064d8c1abbf8aefba22c8246ae92208791dc18b206c19c7d691184fa" => :mojave
    sha256 "87f72e8af710f0cb763187624eedd3e04c56e4e7f1b32e6a80738f388b4079d2" => :high_sierra
    sha256 "24aec1c94dfb2906dbb1ab2e3af3a4208083fe88179e1429568502cc125eb054" => :sierra
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
