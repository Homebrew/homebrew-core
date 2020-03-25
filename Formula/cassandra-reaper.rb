class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/2.0.3/cassandra-reaper-2.0.3.tar.gz"
  sha256 "1140d6b809bdc9d96726254fcec574d475f9a30f48dc12305e56b6d638c00a7c"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    prefix.install "bin"
    share.install "server/target" => "cassandra-reaper"
    etc.install "resource" => "cassandra-reaper"
  end

  test do
    pid = fork do
      exec "#{bin}/cassandra-reaper"
    end
    sleep 10
    output = shell_output("curl -Im3 -o- http://localhost:8080/webui/")
    assert_match /200 OK.*/m, output
  ensure
    Process.kill("KILL", pid)
  end
end
