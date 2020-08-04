class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.6.6.tar.gz"
  sha256 "908f0eecfa559129c9e44edc46f02e73afe8faca355b4efc5c86d902fc3e32f7"
  license "BSD-3-Clause"
  head "https://github.com/memcached/memcached.git"

  bottle do
    cellar :any
    sha256 "e942aa7a5eb09af40e100d242a5f65a7caffa077b7aecd2b94b4e81ce5f9c3ff" => :catalina
    sha256 "72ea783ac973864336ac1b7652475edeb523ce716e66ae4d6f745956429a66f5" => :mojave
    sha256 "47b162f67655a7cc95a706d5df0df04408038d82e4a859cd747b28590921c175" => :high_sierra
  end

  depends_on "libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--disable-coverage", "--enable-tls"
    system "make", "install"
  end

  plist_options manual: "#{HOMEBREW_PREFIX}/opt/memcached/bin/memcached"

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
    system bin/"memcached", "--listen=localhost:#{free_port}", "--daemon", "--pidfile=#{pidfile}"
    sleep 1
    assert_predicate pidfile, :exist?, "Failed to start memcached daemon"
    pid = (testpath/"memcached.pid").read.chomp.to_i
    Process.kill "TERM", pid
  end
end
