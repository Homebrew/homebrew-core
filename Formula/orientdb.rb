class Orientdb < Formula
  desc "Graph database"
  homepage "https://orientdb.org/"
  url "https://search.maven.org/remotecontent?filepath=com/orientechnologies/orientdb-community/3.2.17/orientdb-community-3.2.17.zip"
  sha256 "c292b8453b1c932268dd5e3b8fe40bcfafe73b6a4ef63f7e0fe6bdc725184077"
  license "Apache-2.0"

  livecheck do
    url "https://orientdb.org/download"
    regex(/href=.*?orientdb(?:-community)?[._-]v?(\d+(?:\.\d+)+)\.zip/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "23ea3d242c26807b35f21cd98f06c67232cafb0650ec284c17f9f4040b05f1e1"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4094ff9c1ef0a9190d49afe3959f96150ef20d31afb0979c144ed23272de50b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1a934f970e6c7ed37843fb7941bb3100a86ed5c18480430b4faae1506cfb349a"
    sha256 cellar: :any_skip_relocation, ventura:        "69ba3d78b6c4be0a44fc989cb515856cb7ffbfd0d25105a31ef7468f1684b133"
    sha256 cellar: :any_skip_relocation, monterey:       "09ca0c2110d4527773a3bb39a6ba1574bac12b9cb95208516fca2fea918fbff0"
    sha256 cellar: :any_skip_relocation, big_sur:        "994a94d8d76be5c6b3a62c0d23b88e671d9eb45c9a3eee3aa00aec4281459c97"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "67da92d722ec6a5490eae769868c51b384b51ee916104fe356701db0977c12c0"
  end

  depends_on "maven" => :build
  depends_on "openjdk"

  def install
    rm_rf Dir["bin/*.bat"]

    chmod 0755, Dir["bin/*"]
    libexec.install Dir["*"]

    inreplace "#{libexec}/config/orientdb-server-config.xml", "</properties>",
       <<~EOS
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

    (bin/"orientdb").write_env_script "#{libexec}/bin/orientdb.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-console").write_env_script "#{libexec}/bin/console.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
    (bin/"orientdb-gremlin").write_env_script "#{libexec}/bin/gremlin.sh", JAVA_HOME: Formula["openjdk"].opt_prefix
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

  def caveats
    <<~EOS
      The OrientDB root password was set to 'orientdb'. To reset it:
        https://orientdb.org/docs/3.1.x/security/Server-Security.html#restoring-the-servers-user-root
    EOS
  end

  service do
    run opt_libexec/"bin/server.sh"
    keep_alive true
    working_dir var
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
