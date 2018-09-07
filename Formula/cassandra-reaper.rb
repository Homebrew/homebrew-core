class CassandraReaper < Formula
  desc "Management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.2.2/cassandra-reaper-1.2.2-release.tar.gz"
  sha256 "720aff69e3205301bc07399afc46dae3568d8effffa3712f1852a169ce9801db"

  def install
    inreplace "bin/cassandra-reaper", "etc", etc
    libexec.install "bin/cassandra-reaper"
    share.install "server/target" => "cassandra-reaper"
    etc.install "resource" => "cassandra-reaper"
    env = { :CLASS_PATH => "#{pkgshare}/cassandra-reaper-?.?.?.jar" }
    (bin/"cassandra-reaper").write_env_script(libexec/"cassandra-reaper", env)
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
