class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.1.0/cassandra-reaper-3.1.0-release.tar.gz"
  sha256 "2e0d816a3b3659411be169a245b5e0a1e64c50c1aecaa3b1d33537be4649f297"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "3a959022475e86bf2ab4f93d88c7161e94c3901d066a8792799fbca0e4473f37"
    sha256 cellar: :any_skip_relocation, catalina:     "3a959022475e86bf2ab4f93d88c7161e94c3901d066a8792799fbca0e4473f37"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "fa8b2da0dd6ba8d5bbbddfd0ea2ff2ce93c9ff116a45173b17386d1a0e968da9"
  end

  depends_on "openjdk@8"

  def install
    inreplace "bin/cassandra-reaper", "/usr/share", prefix
    prefix.install "bin"
    etc.install "resource" => "cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"
    inreplace Dir[etc/"cassandra-reaper/*.yaml"], " /var/log", " #{var}/log"
  end

  service do
    run opt_bin/"cassandra-reaper"
    environment_variables JAVA_HOME: Formula["openjdk@8"].opt_prefix
    keep_alive true
    error_log_path var/"log/cassandra-reaper/service.err"
    log_path var/"log/cassandra-reaper/service.log"
  end

  test do
    ENV["JAVA_HOME"] = Formula["openjdk@8"].opt_prefix
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
