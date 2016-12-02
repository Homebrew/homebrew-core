class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.13.tar.gz"
  sha256 "ad8e01b5ac105911167a3534093fe92753ffe4e3632c308f965be2d722925ce3"

  bottle do
    cellar :any_skip_relocation
    sha256 "1281edfb9396ca133d16f1af0faf78d5aaf6c5abe8d42f5e96e36913b4fe44db" => :sierra
    sha256 "6ca2f994653590ac3f04ace2ddd369b0f66d5b648c5a151c5c592d7aab5ca982" => :el_capitan
    sha256 "356a546861606b228294421816f188ed42f4a05d234ee7e1c96e4ccc8f03ade5" => :yosemite
    sha256 "b065a2a8527b54005b7b9b65c395491700a165f56c4c22ab4523018a15816ebc" => :mavericks
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
