class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "https://cassandra-reaper.io/"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/2.3.1/cassandra-reaper-2.3.1-release.tar.gz"
  sha256 "3a6633e43ea99d295f61067f948d9918689589d70e09a541310c4c9fa9ecc268"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "fb19757d6d28a30eed71836a8e674e366ca4ac809fddc845f9f2a4f7cd602414"
  end

  depends_on arch: :x86_64 # openjdk@8 does not support ARM
  depends_on "openjdk@8"

  def install
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
