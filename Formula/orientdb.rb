class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com/"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.19.tar.gz"
  sha256 "877a9534cdc5cce51aa0e8dfb02be71be0eb4be1d0da0365d2600b8601daace9"

  bottle do
    cellar :any_skip_relocation
    sha256 "ea3725e7b685560f9455fa98bb22e171b818392d5e9c4cb2e8340639db0baa73" => :sierra
    sha256 "94194fa38f110c3c0c6e9950d6b17f6dcbd0411df2b2e0c5f7b4c9f53617b310" => :el_capitan
    sha256 "94194fa38f110c3c0c6e9950d6b17f6dcbd0411df2b2e0c5f7b4c9f53617b310" => :yosemite
  end

  def install
    rm_rf Dir["{bin,benchmarks}/*.{bat,exe}"]

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<-EOS.undent
         <entry name="server.database.path" value="#{var}/db/orientdb" />
         </properties>
       EOS
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/server.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/shutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec
    inreplace "#{libexec}/bin/orientdb.sh", 'su $ORIENTDB_USER -c "cd \"$ORIENTDB_DIR/bin\";', ""
    inreplace "#{libexec}/bin/orientdb.sh", '&"', "&"

    bin.install_symlink "#{libexec}/bin/orientdb.sh" => "orientdb"
    bin.install_symlink "#{libexec}/bin/console.sh" => "orientdb-console"
    bin.install_symlink "#{libexec}/bin/gremlin.sh" => "orientdb-gremlin"
  end

  def post_install
    (var/"db/orientdb").mkpath
    (var/"run/orientdb").mkpath
    (var/"log/orientdb").mkpath
    touch "#{var}/log/orientdb/orientdb.err"
    touch "#{var}/log/orientdb/orientdb.log"

    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"
    system "#{bin}/orientdb", "stop"
    sleep 3
    system "#{bin}/orientdb", "start"
    sleep 3

  ensure
    system "#{bin}/orientdb", "stop"
  end

  def caveats; <<-EOS.undent
    The OrientDB root password was set to 'orientdb'. To reset it:
      https://orientdb.com/docs/2.2/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  plist_options :manual => "orientdb start"

  def plist; <<-EOS.undent
    <?xml version="1.0" encoding="UTF-8"?>
    <!DOCTYPE plist PUBLIC "-//Apple//DTD PLIST 1.0//EN" "http://www.apple.com/DTDs/PropertyList-1.0.dtd">
    <plist version="1.0">
      <dict>
        <key>KeepAlive</key>
          <dict>
            <key>SuccessfulExit</key>
            <false/>
          </dict>
        <key>Label</key>
        <string>homebrew.mxcl.orientdb</string>
        <key>ProgramArguments</key>
        <array>
          <string>/usr/local/opt/orientdb/libexec/bin/server.sh</string>
        </array>
        <key>RunAtLoad</key>
        <true/>
        <key>WorkingDirectory</key>
        <string>/usr/local/var</string>
        <key>StandardErrorPath</key>
        <string>/usr/local/var/log/orientdb/serror.log</string>
        <key>StandardOutPath</key>
        <string>/usr/local/var/log/orientdb/sout.log</string>
      </dict>
    </plist>
    EOS
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    begin
      assert_match "OrientDB console v.#{version}", pipe_output("#{bin}/orientdb-console \"exit;\"")
    end
  end
end
