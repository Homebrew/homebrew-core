class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.dev"
  url "https://search.maven.org/remotecontent?filepath=com/orientechnologies/orientdb-community/3.2.55/orientdb-community-3.2.55.zip"
  sha256 "3486b70d5013d961e272e0c0d681cf85dd8df6b23c028e0e671c246097fdf3f1"
  license "Apache-2.0"

  livecheck do
    url "https://orientdb.dev/downloads/"
    regex(/href=.*?orientdb-community[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, all: "ab2ca757924b9ddddd8766ef5a69e2f621b5798bec9bf08f591a695b1b8432ed"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    rm_r(Dir["bin/*.bat"])

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<~XML
         <entry name="server.database.path" value="#{var}/db/orientdb" />
         </properties>
       XML
    inreplace "#{libexec}/config/orientdb-server-log.properties", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", "../log", "#{var}/log/orientdb"
    inreplace "#{libexec}/bin/server.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/shutdown.sh", "ORIENTDB_PID=$ORIENTDB_HOME/bin", "ORIENTDB_PID=#{var}/run/orientdb"
    inreplace "#{libexec}/bin/orientdb.sh", '"YOUR_ORIENTDB_INSTALLATION_PATH"', libexec
    inreplace "#{libexec}/bin/orientdb.sh", 'su $ORIENTDB_USER -c "cd \"$ORIENTDB_DIR/bin\";', ""
    inreplace "#{libexec}/bin/orientdb.sh", '&"', "&"

    (bin/"orientdb").write_env_script "#{libexec}/bin/orientdb.sh", JAVA_HOME: formula_opt_prefix("openjdk")
    (bin/"orientdb-console").write_env_script "#{libexec}/bin/console.sh", JAVA_HOME: formula_opt_prefix("openjdk")
    (bin/"orientdb-gremlin").write_env_script "#{libexec}/bin/gremlin.sh", JAVA_HOME: formula_opt_prefix("openjdk")

    (libexec/"post-install").write <<~SH
      #!/bin/sh
      set -e
      orientdb="#{opt_bin}/orientdb"
      cleanup() { ORIENTDB_ROOT_PASSWORD=orientdb "$orientdb" stop; }
      trap cleanup EXIT
      ORIENTDB_ROOT_PASSWORD=orientdb "$orientdb" stop
      sleep 3
      ORIENTDB_ROOT_PASSWORD=orientdb "$orientdb" start
      sleep 3
      trap - EXIT
      cleanup
    SH
    chmod 0755, libexec/"post-install"

    (var/"db/orientdb").mkpath
    (var/"run/orientdb").mkpath
    (var/"log/orientdb").mkpath
  end

  post_install_steps do
    touch "{{var}}/log/orientdb/orientdb.err"
    touch "{{var}}/log/orientdb/orientdb.log"
    run "post-install", base: :libexec
  end

  def caveats
    <<~EOS
      The OrientDB root password was set to 'orientdb'. To reset it:
        https://orientdb.org/docs/3.1.x/security/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  service do
    run opt_libexec/"bin/server.sh"
    keep_alive true
    working_dir var/"orientdb"
    log_path var/"log/orientdb/sout.log"
    error_log_path var/"log/orientdb/serror.log"
  end

  test do
    ENV["CONFIG_FILE"] = "#{testpath}/orientdb-server-config.xml"
    ENV["ORIENTDB_ROOT_PASSWORD"] = "orientdb"

    cp "#{libexec}/config/orientdb-server-config.xml", testpath
    inreplace "#{testpath}/orientdb-server-config.xml", "</properties>",
      "  <entry name=\"server.database.path\" value=\"#{testpath}\" />\n    </properties>"

    assert_match "OrientDB console v.#{version}", pipe_output("#{bin}/orientdb-console \"exit;\"")
  end
end
