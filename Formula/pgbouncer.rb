class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://www.pgbouncer.org/"
  url "https://www.pgbouncer.org/downloads/files/1.14.0/pgbouncer-1.14.0.tar.gz"
  sha256 "a0c13d10148f557e36ff7ed31793abb7a49e1f8b09aa2d4695d1c28fa101fee7"

  bottle do
    cellar :any
    sha256 "eaecbb143f281ccc047d7a63488038c2d53de7ffaf56b56e532dce7089e30106" => :catalina
    sha256 "c86c7f6b7fa11965e9427aeb36bc334b6f7f31323d826350736813187622844f" => :mojave
    sha256 "4e098f2929939ba16d03e194310df111929dd861e02e89f075ce726f8f67b49d" => :high_sierra
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

  plist_options manual: "pgbouncer -q #{HOMEBREW_PREFIX}/etc/pgbouncer.ini"

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
