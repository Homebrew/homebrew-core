class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.13.tar.gz"
  sha256 "ad8e01b5ac105911167a3534093fe92753ffe4e3632c308f965be2d722925ce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "8813783518d6c3a88ba85328daa82075a9ce51cb66309ab2e98aef3901a818d6" => :sierra
    sha256 "8813783518d6c3a88ba85328daa82075a9ce51cb66309ab2e98aef3901a818d6" => :el_capitan
    sha256 "8813783518d6c3a88ba85328daa82075a9ce51cb66309ab2e98aef3901a818d6" => :yosemite
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
      http://orientdb.com/docs/2.2/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    begin
      assert_match /OrientDB console v.2.2.13/, pipe_output("#{bin}/orientdb-console \"exit;\"")
    end
  end
end
