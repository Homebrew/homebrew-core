class Arcadedb < Formula
  desc "Multi-Model DBMS: Graph, Document, Key/Value, Search, Time Series, Vector"
  homepage "https://arcadedb.com"
  url "https://github.com/ArcadeData/arcadedb/releases/download/26.7.3/arcadedb-26.7.3.tar.gz"
  sha256 "eec0cd2a669f8050d81d3d91fa53b12eee0a6a682c307cd484508f7d3b08305f"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "9dff2fb461f6b9b1f8994624bdd8c740b053b40a7bd91a90b736066c52b92124"
  end

  depends_on "openjdk"

  def install
    rm Dir["bin/*.bat"]
    libexec.install Dir["*"]

    env = {
      JAVA_HOME:                 formula_opt_prefix("openjdk"),
      ARCADEDB_HOME:             libexec,
      ARCADEDB_SERVER_ROOT_PATH: var/"arcadedb",
    }

    (bin/"arcadedb-server").write_env_script libexec/"bin/server.sh", env
    (bin/"arcadedb-console").write_env_script libexec/"bin/console.sh", env
    (var/"arcadedb/databases").mkpath
    (var/"arcadedb/backups").mkpath
    (var/"arcadedb/config").mkpath
  end

  post_install_steps do
    unless_path_exists "arcadedb/config/arcadedb-log.properties" do
      copy "config/arcadedb-log.properties", "arcadedb/config/arcadedb-log.properties",
           source_base: :libexec, target_base: :var
    end
    unless_path_exists "arcadedb/config/server-groups.json" do
      copy "config/server-groups.json", "arcadedb/config/server-groups.json",
           source_base: :libexec, target_base: :var
    end
    unless_path_exists "arcadedb/config/gremlin-server.yaml" do
      copy "config/gremlin-server.yaml", "arcadedb/config/gremlin-server.yaml",
           source_base: :libexec, target_base: :var
    end
    unless_path_exists "arcadedb/config/gremlin-server.groovy" do
      copy "config/gremlin-server.groovy", "arcadedb/config/gremlin-server.groovy",
           source_base: :libexec, target_base: :var
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
