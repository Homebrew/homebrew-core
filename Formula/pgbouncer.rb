class Pgbouncer < Formula
  desc "Lightweight connection pooler for PostgreSQL"
  homepage "https://wiki.postgresql.org/wiki/PgBouncer"
  url "https://pgbouncer.github.io/downloads/files/1.10.0/pgbouncer-1.10.0.tar.gz"
  sha256 "d8a01442fe14ce3bd712b9e2e12456694edbbb1baedb0d6ed1f915657dd71bd5"
  revision 1

  bottle do
    cellar :any
    sha256 "384847d94a32a727f4fddab27ced3e6447632914f9fd24a3565d33d067d747a4" => :mojave
    sha256 "398ab8f68501635643ff3b7a73625bd307b6c35c658b754215e8f07c9fc2a60c" => :high_sierra
    sha256 "1d7245f605561cef85606a117e071d79cf03f22ce50751d2ca492654c7c9ac54" => :sierra
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
