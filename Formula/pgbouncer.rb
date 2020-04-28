class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.13.0/pgbouncer-1.13.0.tar.gz"
  sha256 "4cb821c95f05625594355bba89c139f2a4e062af221c2135bf0526b920c89d31"

  bottle do
    cellar :any
    sha256 "e01f2d531e6ef62c29614c8eb435d311733e44206d7da4e78e6853ddb339bb07" => :catalina
    sha256 "1c9de5a71cf7c54d92802adefe2ce68ef0db48bc6619b06e2cf2741164330927" => :mojave
    sha256 "387cf0cf1819be2442ed9b3acd89815b4c5b3bc6a3386641568a70eaa62c6100" => :high_sierra
  end

  depends_on "pkg-config" => :build
  depends_on "libevent"
  depends_on "openssl@1.1"

  def install
    system "./configure", "--disable-debug",
                          "--prefix=#{prefix}"
    system "make", "install"
    bin.install "etc/mkauth.py"
    inreplace "etc/pgbouncer.ini" do |s|
      s.gsub! /logfile = .*/, "logfile = #{var}/log/pgbouncer.log"
      s.gsub! /pidfile = .*/, "pidfile = #{var}/run/pgbouncer.pid"
      s.gsub! /auth_file = .*/, "auth_file = #{etc}/userlist.txt"
    end
    etc.install %w[etc/pgbouncer.ini etc/userlist.txt]
  end

  def caveats
    <<~EOS
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
