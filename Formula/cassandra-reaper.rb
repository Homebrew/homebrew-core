class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/2.0.2/cassandra-reaper-2.0.2-release.tar.gz"
  sha256 "3cd35c348bc59dc2bfe5bfc2afc9b2f61da9600a1ca9a55b5cbbbe90508c0238"

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
