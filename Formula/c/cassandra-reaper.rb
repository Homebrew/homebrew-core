class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.6.1/cassandra-reaper-3.6.1-release.tar.gz"
  sha256 "8e5004692d031e2abe47c26c066d853fb1f841b23833edd66d58ff54bef82399"
  license "Apache-2.0"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, all: "d3600523c5e7a0f11954710872d7a2b5d1ae39240779ccf37e6e762f683e5feb"
  end

  depends_on "openjdk@11"

  def install
    inreplace Dir["resource/*.yaml"], " /var/log", " #{var}/log"
    inreplace "bin/cassandra-reaper", "/usr/local/share", share
    inreplace "bin/cassandra-reaper", "/usr/local/etc", etc

    libexec.install "bin/cassandra-reaper"
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"

    (bin/"cassandra-reaper").write_env_script libexec/"cassandra-reaper",
      Language::Java.overridable_java_home_env("11")
  end

  service do
    run opt_bin/"cassandra-reaper"
    keep_alive true
    error_log_path var/"log/cassandra-reaper/service.err"
    log_path var/"log/cassandra-reaper/service.log"
  end

  test do
    cp etc/"cassandra-reaper/cassandra-reaper.yaml", testpath
    port = free_port
    inreplace "cassandra-reaper.yaml" do |s|
      s.gsub! "port: 8080", "port: #{port}"
      s.gsub! "port: 8081", "port: #{free_port}"
      s.gsub! "storageType: memory", "storageType: memory\npersistenceStoragePath: #{testpath}/persistence"
    end

    fork do
      exec bin/"cassandra-reaper", testpath/"cassandra-reaper.yaml"
    end
    sleep 40
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
