class Pincaster < Formula
  desc "Nosql database with a HTTP/JSON interface"
  homepage "https://github.com/jedisct1/Pincaster"
  url "https://download.pureftpd.org/pincaster/releases/pincaster-0.6.tar.bz2"
  sha256 "c88be055ecf357b50b965afe70b5fc15dff295fbe2b6f0c473cf7e4a795a9f97"
  revision 1

  bottle do
    rebuild 1
    sha256 "e1cdc55085e31ff199e4beb9726ae30100f3e729d116d8b10d730ae6ebfb07d2" => :mojave
    sha256 "434c3551a2707f2197913a767c90ddb00ff5d542408379aeac623254d0594332" => :high_sierra
    sha256 "77649ce6e3ab74ca1a58f15e7764ee467fc8de69a2b56f2fa03d1c5f0324e93d" => :sierra
    sha256 "217521a03c99cdf721cefb339c4a1d5fb61b7838116b49bded875dbe2cfceb65" => :el_capitan
  end

  depends_on "openssl"

  conflicts_with "libevent", :because => "Pincaster embeds libevent"

  def install
    system "./configure", "--prefix=#{prefix}", "--with-yajl=embedded"
    system "make", "install"

    inreplace "pincaster.conf" do |s|
      s.gsub! "/var/db/pincaster/pincaster.db", "#{var}/db/pincaster/pincaster.db"
      s.gsub! "# LogFileName       /tmp/pincaster.log", "LogFileName  #{var}/log/pincaster.log"
    end

    etc.install "pincaster.conf"
    (var/"db/pincaster/").mkpath
  end

  plist_options :manual => "pincaster #{HOMEBREW_PREFIX}/etc/pincaster.conf"

  def plist; <<~EOS
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
          <string>#{opt_bin}/pincaster</string>
          <string>#{etc}/pincaster.conf</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>#{var}</string>
        <key>StandardErrorPath</key>
        <string>#{var}/log/pincaster.log</string>
        <key>StandardOutPath</key>
        <string>#{var}/log/pincaster.log</string>
      </dict>
    </plist>
  EOS
  end

  test do
    cp etc/"pincaster.conf", testpath
    inreplace "pincaster.conf", "/usr/local/var", testpath/"var"
    (testpath/"var/db/pincaster/").mkpath
    (testpath/"var/log").mkpath

    pid = fork do
      exec "#{bin}/pincaster pincaster.conf"
    end
    sleep 2

    begin
      assert_match /pong":"pong"/, shell_output("curl localhost:4269/api/1.0/system/ping.json")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
