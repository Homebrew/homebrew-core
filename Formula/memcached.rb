class Memcached < Formula
  desc "High performance, distributed memory object caching system"
  homepage "https://memcached.org/"
  url "https://www.memcached.org/files/memcached-1.4.35.tar.gz"
  sha256 "f4815ac95aa06c0f360052a0a12010533b2b78c3bfe475b171606c1b61469476"

  bottle do
    cellar :any
    sha256 "e2eb1c84fd921b949606ec1c0102ba62a1f365a3fc091c720ac78c86efa17a98" => :sierra
    sha256 "b2345fa0cda0e8217d42933bc670501f89364f7e1fee12a02a88f56db697df9d" => :el_capitan
    sha256 "052fbcbf4ca1acac8671f39f0658766c7b75f6a8d4d666d44f432c49f67a82ac" => :yosemite
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

  def plist; <<-EOS.undent
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
    system "#{bin}/memcached", "-h"
  end
end
