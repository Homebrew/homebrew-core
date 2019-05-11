class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.4.2/cassandra-reaper-1.4.2-release.tar.gz"
  sha256 "9deba7bf79cffecd97f11ceac5208a16fb4ad1becbd1676ab24086f9c43aab7f"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    prefix.install "bin"
    share.install "server/target" => "cassandra-reaper"
    etc.install "resource" => "cassandra-reaper"
  end

  test do
    begin
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
end
