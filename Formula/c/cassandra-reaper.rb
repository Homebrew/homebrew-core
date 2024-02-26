class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.5.0/cassandra-reaper-3.5.0-release.tar.gz"
  sha256 "86eda426fb1cf2b1c9bcd068177b87afb14e43f5522611763f76d022ce510e50"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "593e0b6fea0afa70b8f897ce3b1cd6a6f08d99d228429043cafc9081ae504f2e"
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
    end
    fork do
      exec "#{bin}/cassandra-reaper", "#{testpath}/cassandra-reaper.yaml"
    end
    sleep 30
    assert_match "200 OK", shell_output("curl -Im3 -o- http://localhost:#{port}/webui/login.html")
  end
end
