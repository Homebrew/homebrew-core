class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/4.1.0/cassandra-reaper-4.1.0-release.tar.gz"
  sha256 "a28b65edd14e9a1814924d33a3502c30397764c3e9ba4ae9e9329c371f3c2314"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3dca00357dcf17314eb187455f19cf7a9d96b35d2aa804630f5b5c9981ffa34d"
  end

  depends_on "openjdk"

  def install
    inreplace Dir["resource/*.yaml"], " /var/log", " #{var}/log"
    inreplace "bin/cassandra-reaper", "/usr/local/share", share
    inreplace "bin/cassandra-reaper", "/usr/local/etc", etc

    libexec.install "bin/cassandra-reaper"
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"

    (bin/"cassandra-reaper").write_env_script libexec/"cassandra-reaper",
                                              Language::Java.overridable_java_home_env
  end

  service do
    run opt_bin/"cassandra-reaper"
    keep_alive true
    error_log_path var/"log/cassandra-reaper/service.err"
    log_path var/"log/cassandra-reaper/service.log"
  end

  test do
    ENV["REAPER_AUTH_USER"] = "admin"
    ENV["REAPER_AUTH_PASSWORD"] = "admin"
    ENV["REAPER_READ_USER"] = ""
    ENV["REAPER_READ_USER_PASSWORD"] = ""

    cp etc/"cassandra-reaper/cassandra-reaper.yaml", testpath
    port = free_port
    inreplace "cassandra-reaper.yaml" do |s|
      s.gsub! "port: 8080", "port: #{port}"
      s.gsub! "port: 8081", "port: #{free_port}"
      s.gsub! "storageType: memory", "storageType: memory\npersistenceStoragePath: #{testpath}/persistence"
    end

    spawn bin/"cassandra-reaper", testpath/"cassandra-reaper.yaml"
    sleep 40
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
