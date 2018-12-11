class Couchdb < Formula
  desc "Document database server"
  homepage "https://couchdb.apache.org/"
  url "https://www.apache.org/dyn/closer.lua?path=/couchdb/source/2.3.0/apache-couchdb-2.3.0.tar.gz"
  sha256 "0b3868d042b158d9fd2f504804abd93cd22681c033952f832ce846672c31f352"

  bottle do
    sha256 "81a9ef09e872ead7a3ae847f57f6cd01f4e7e46384c456b1cf4162cf7eecab42" => :mojave
    sha256 "726a7e2329d938f0d64552a2b5c724fc665b5de8b1d046c9fdbd270cf941ba44" => :high_sierra
    sha256 "3b5ed55595f163362f6a583a13fae6353c79b2cf9e66f0d35bcf7e5f13a38613" => :sierra
  end

  depends_on "erlang@19"
  depends_on "icu4c"
  depends_on "spidermonkey"

  def install
    system "./configure"
    system "make", "release"

    # No `make install` sadly
    prefix.install Dir["rel/couchdb/*"]
  end

  def post_install
    (var/"lib/couchdb").mkpath
    (var/"log/couchdb").mkpath
    (var/"run/couchdb").mkpath
  end

  plist_options :manual => "couchdb"

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
        <string>#{opt_bin}/couchdb</string>
      </array>
      <key>RunAtLoad</key>
      <true/>
    </dict>
    </plist>
  EOS
  end

  test do
    # Ensure couchdb embedded spidermonkey vm works
    system "#{bin}/couchjs", "-h"

    (testpath/"var/lib/couchdb").mkpath
    (testpath/"var/log/couchdb").mkpath
    (testpath/"var/run/couchdb").mkpath
    cp_r etc/"couchdb", testpath

    pid = fork do
      exec "#{bin}/couchdb -A #{testpath}/couchdb"
    end
    sleep 2

    begin
      assert_match "Homebrew", shell_output("curl -# localhost:5984")
    ensure
      Process.kill("SIGINT", pid)
      Process.wait(pid)
    end
  end
end
