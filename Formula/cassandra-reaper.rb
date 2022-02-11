class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/3.1.1/cassandra-reaper-3.1.1-release.tar.gz"
  sha256 "8d71f6e74306f4ef33cc1af6822d7a3702f347355589d66cd899ce546df12d1e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, big_sur:      "033a478cada5d4122b9d901933c04dff244766217b4011c54e903e698c8f30ed"
    sha256 cellar: :any_skip_relocation, catalina:     "033a478cada5d4122b9d901933c04dff244766217b4011c54e903e698c8f30ed"
    sha256 cellar: :any_skip_relocation, x86_64_linux: "1332882726428c2293357e513c45fa9be9572dfefdebccaac29323b099e6f870"
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
