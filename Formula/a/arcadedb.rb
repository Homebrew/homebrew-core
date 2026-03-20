class Arcadedb < Formula
  desc "Multi-Model DBMS: Graph, Document, Key/Value, Search, Time Series, Vector"
  homepage "https://arcadedb.com"
  url "https://github.com/ArcadeData/arcadedb/releases/download/26.3.1/arcadedb-26.3.1.tar.gz"
  sha256 "d7a88cdadbf3850dae017a55a85f4d9924b2f98537a20d71f0e8b8af44fdc65d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "747217f2421f82b8dbfdb4bffb15dcf89dd6ae8db8bc6ef8b6e4b03e256b17c7"
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
