class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://wiki.postgresql.org/wiki/PgBouncer"
  url "https://pgbouncer.github.io/downloads/files/1.8.1/pgbouncer-1.8.1.tar.gz"
  sha256 "fa8bde2a2d2c8c80d53a859f8e48bc6713cf127e31c77d8f787bbc1d673e8dc8"

  bottle do
    cellar :any
    sha256 "0d93dc6d4c3aedb41bf98026a4dabdbb042c679dc301bcbb863eee8bcae0c285" => :high_sierra
    sha256 "856e2b0f818374b88290b5d794f9e41d691da1a164d14aedf6ef6192d726d67a" => :sierra
    sha256 "90de8ccdfe3cd6f84de801a5c003c01b95dd6f95eea77620d9be859e78a4d288" => :el_capitan
    sha256 "14b72883c284c2ca5602f29cf393b4c289c77033c6c47596fe8eb9b26245c8ab" => :yosemite
  end

  depends_on "asciidoc" => :build
  depends_on "xmlto" => :build
  depends_on "libevent"

  def install
    ENV["XML_CATALOG_FILES"] = "#{etc}/xml/catalog"

    system "./configure", "--disable-debug",
                          "--with-libevent=#{HOMEBREW_PREFIX}",
                          "--prefix=#{prefix}"
    ln_s "../install-sh", "doc/install-sh"
    system "make", "install"
    bin.install "etc/mkauth.py"
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def caveats; <<~EOS
    The config file: #{etc}/pgbouncer.ini is in the "ini" format and you
    will need to edit it for your particular setup. See:
    https://pgbouncer.github.io/config.html

    The auth_file option should point to the #{etc}/userlist.txt file which
    can be populated by the #{bin}/mkauth.py script.
    EOS
  end

  plist_options :manual => "pgbouncer -q #{HOMEBREW_PREFIX}/etc/pgbouncer.ini"

  def plist
    <<~EOS
      <?xml version="1.0" encoding="UTF-8"?>
      <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
      <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
        <true/>
        <key>Label</key>
        <string>#{plist_name}</string>
        <key>ProgramArguments</key>
        <array>
          <string>#{opt_bin}/pgbouncer</string>
          <string>-d</string>
          <string>-q</string>
          <string>#{etc}/pgbouncer.ini</string>
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
    assert_match version.to_s, shell_output("#{bin}/pgbouncer -V")
  end
end
