class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://wiki.postgresql.org/wiki/PgBouncer"
  url "https://pgbouncer.github.io/downloads/files/1.10.0/pgbouncer-1.10.0.tar.gz"
  sha256 "d8a01442fe14ce3bd712b9e2e12456694edbbb1baedb0d6ed1f915657dd71bd5"
  revision 1

  bottle do
    cellar :any
    sha256 "47856e33e4e537ee50b39573d63f1366f332b57d57be21a797bd7da6d19eb11b" => :mojave
    sha256 "728418195cb273b74d67b791a0e9834cbc7dc9828f928c9dd44fe015e404b117" => :high_sierra
    sha256 "ec357f9ba0bd22a1f34b0ce1d9174376ba4aedf43904318430cd109f076a4188" => :sierra
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
