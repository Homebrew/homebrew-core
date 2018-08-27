class CassandraReaper < Formula
  desc "CassandraReaper manager for Homebrew"
  homepage "http://cassandra-reaper.io"
  url "https://github.com/thelastpickle/cassandra-reaper/releases/download/1.2.2/cassandra-reaper-1.2.2-release.tar.gz"
  sha256 "720aff69e3205301bc07399afc46dae3568d8effffa3712f1852a169ce9801db"

  def install
    prefix.install "bin"
    mv "server/target", "cassandra-reaper"
    share.install "cassandra-reaper"
    mv "resource", "cassandra-reaper"
    etc.install "cassandra-reaper"
  end
end
