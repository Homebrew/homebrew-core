class CassandraReaper < Formula
  desc "CassandraReaper manager for Homebrew"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.2.2/cassandra-reaper-1.2.2-release.tar.gz"
  sha256 "720aff69e3205301bc07399afc46dae3568d8effffa3712f1852a169ce9801db"


  patch :p3 do
    url "https://github.com/thelastpickle/cassandra-reaper/commit/4e26e1c70de8aa564e57ada287fffd6e7544914f.diff"
    sha256 "0b1812e1121225fdcaaf97c2a9db00010ddc055ea14efd9674e5621fd4510bf9"
  end

  def install
    prefix.install "bin"
    mv "server/target", "cassandra-reaper"
    share.install "cassandra-reaper"
    mv "resource", "cassandra-reaper"
    etc.install "cassandra-reaper"
  end


  test do
    begin
      pid = fork do
        exec "/usr/local/bin/cassandra-reaper"
      end
      sleep 10
      output = shell_output("curl -Im3 -o- http://localhost:8080/webui/")
      assert_match /200 OK.*/m, output
    ensure
      Process.kill("KILL", pid)
    end
  end

end
