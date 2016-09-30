class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.com"
  url "https://orientdb.com/download.php?file=orientdb-community-2.2.5.tar.gz"
  sha256 "958d479beeabeb5658c23460bf29043a7a4b80c0d238f36e586e3b108f12bae0"

  bottle do
    cellar :any_skip_relocation
    sha256 "1281edfb9396ca133d16f1af0faf78d5aaf6c5abe8d42f5e96e36913b4fe44db" => :sierra
    sha256 "6ca2f994653590ac3f04ace2ddd369b0f66d5b648c5a151c5c592d7aab5ca982" => :el_capitan
    sha256 "356a546861606b228294421816f188ed42f4a05d234ee7e1c96e4ccc8f03ade5" => :yosemite
    sha256 "b065a2a8527b54005b7b9b65c395491700a165f56c4c22ab4523018a15816ebc" => :mavericks
  end

  # Fixing OrientDB init scripts
  patch do
    url "https://gist.githubusercontent.com/maggiolo00/84835e0b82a94fe9970a/raw/1ed577806db4411fd8b24cd90e516580218b2d53/orientdbsh"
    sha256 "d8b89ecda7cb78c940b3c3a702eee7b5e0f099338bb569b527c63efa55e6487e"
  end

  def install
    rm_rf Dir["{bin,benchmarks}/*.{bat,exe}"]

    inreplace %W[bin/orientdb.sh bin/console.sh bin/gremlin.sh],
      '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec

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
  end

  def caveats
    "Use `orientdb <start | stop | status>`, `orientdb-console` and `orientdb-gremlin`."
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>", "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    system "#{bin}/orientdb", "start"
    sleep 4

    begin
      assert_match "OrientDB Server v.2.2.5", shell_output("curl -I localhost:2480")
    ensure
      system "#{bin}/orientdb", "stop"
    end
  end
end
