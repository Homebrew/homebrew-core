class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.5.9.tar.gz"
  sha256 "4af3577dbf71cb0a748096dc6562ccd587cddb7565c720f1fdb23e8a34241d06"

  bottle do
    cellar :any
    sha256 "16e9c90f9a3e364c8976835aeb7985ec5c5de73d7574c80a8826088da6962e61" => :high_sierra
    sha256 "c15e53fbe5df3216e33c43f3b074fb720f6f584248082fb69c8ae0b830380dea" => :sierra
    sha256 "77656a92ef82ecd7f850e56dc7c5f9313bbabe72d40db851147abce6fe6d2697" => :el_capitan
  end

  option "with-sasl", "Enable SASL support -- disables ASCII protocol!"
  option "with-sasl-pwdb", "Enable SASL with memcached's own plain text password db support -- disables ASCII protocol!"

  depends_on "libevent"

  deprecated_option "enable-sasl" => "with-sasl"
  deprecated_option "enable-sasl-pwdb" => "with-sasl-pwdb"

  conflicts_with "mysql-cluster", :because => "both install `bin/memcached`"

  def install
    args = ["--prefix=#{prefix}", "--disable-coverage"]
    args << "--enable-sasl" if build.with? "sasl"
    args << "--enable-sasl-pwdb" if build.with? "sasl-pwdb"

    system "./configure", *args
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
