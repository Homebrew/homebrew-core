class Arcadedb < Formula
  desc "Multi-Model DBMS: Graph, Document, Key/Value, Search, Time Series, Vector"
  homepage "https://arcadedb.com"
  url "https://github.com/ArcadeData/arcadedb/releases/download/26.4.2/arcadedb-26.4.2.tar.gz"
  sha256 "465e13981171e31f3c35f6fc3775614337faac5bce67e8082fe501f223cac38c"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "02784c3be3a41bf5e3d26156746b22bd9fbabc860f48659b69b2eb81243d826e"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]

    env = {
      JAVA_HOME:                 Formula["openjdk"].opt_prefix,
      ARCADEDB_HOME:             libexec,
      ARCADEDB_SERVER_ROOT_PATH: var/"arcadedb",
    }

    (bin/"arcadedb-server").write_env_script libexec/"bin/server.sh", env
    (bin/"arcadedb-console").write_env_script libexec/"bin/console.sh", env
    (var/"arcadedb/databases").mkpath
    (var/"arcadedb/backups").mkpath
    (var/"arcadedb/config").mkpath
    (var/"log/arcadedb").mkpath
  end

  def post_install
    %w[arcadedb-log.properties server-groups.json gremlin-server.yaml gremlin-server.groovy].each do |f|
      target = var/"arcadedb/config"/f
      cp libexec/"config"/f, target unless target.exist?
    end
  end

  service do
    run opt_bin/"arcadedb-server"
    working_dir var/"arcadedb"
    log_path var/"log/arcadedb/server.log"
    error_log_path var/"log/arcadedb/server-error.log"
    keep_alive true
  end

  def caveats
    <<~EOS
      To set the root password on first run:
        arcadedb-server -Darcadedb.server.rootPassword=yourpassword

      Data:    #{var}/arcadedb/databases
      Config:  #{var}/arcadedb/config
    EOS
  end

  test do
    port = free_port
    pid = fork do
      ENV["ARCADEDB_JMX"] = " "
      exec bin/"arcadedb-server",
           "-Darcadedb.server.httpIncomingHost=127.0.0.1",
           "-Darcadedb.server.httpIncomingPort=#{port}",
           "-Darcadedb.server.databaseDirectory=#{testpath}/databases",
           "-Darcadedb.server.rootPassword=playwithdata"
    end
    sleep 15
    begin
      system "curl", "-sf", "http://127.0.0.1:#{port}/api/v1/ready"
    ensure
      Process.kill("TERM", pid)
      Process.wait(pid)
    end
  end
end
