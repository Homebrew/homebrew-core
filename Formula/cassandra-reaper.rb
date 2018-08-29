class CassandraReaper < Formula
  desc "A management interface for Cassandra"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.2.2/cassandra-reaper-1.2.2-release.tar.gz"
  sha256 "720aff69e3205301bc07399afc46dae3568d8effffa3712f1852a169ce9801db"

  # The inline patch is temporary to update the 'cassandra-reaper' script for reading from /usr/local/.
  # Since PR [thelastpickle/cassandra-reaper#533](https://github.com/thelastpickle/cassandra-reaper/pull/533) is merged, it will be obsolete once next version is released.
  patch :p3 do
    url "https://github.com/thelastpickle/cassandra-reaper/commit/4e26e1c70de8aa564e57ada287fffd6e7544914f.patch?full_index=1"
    sha256 "7fdea1d12524e121db191c70effa91825948fa08b24b2c914d51dbfdceff485a"
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
