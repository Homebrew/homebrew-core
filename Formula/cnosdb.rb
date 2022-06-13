class Cnosdb < Formula
  desc "Open source distributed time series database"
  homepage "https://www.cnosdb.com"
  url "https://github.com/cnosdb/cnosdb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "ae412d0944b64c9b39dc1edc66f7b6f712b85bc5afad354c12b135ae71017100"
  license "MIT"
  head "https://github.com/cnosdb/cnosdb.git"

  depends_on "go" => :build

  def install
    ENV["GOBIN"] = buildpath
    system "go", "install", "./..."
    bin.install %w[cnosdb cnosdb-cli cnosdb-ctl cnosdb-meta cnosdb-inspect cnosdb-tools]
    etc.install "etc/cnosdb.sample.toml" => "cnosdb.conf"
    inreplace etc/"cnosdb.conf" do |s|
      s.gsub! "/var/lib/cnosdb/data", "#{var}/cnosdb/data"
      s.gsub! "/var/lib/cnosdb/meta", "#{var}/cnosdb/meta"
      s.gsub! "/var/lib/cnosdb/wal", "#{var}/cnosdb/wal"
    end
    (var/"cnosdb/data").mkpath
    (var/"cnosdb/meta").mkpath
    (var/"cnosdb/wal").mkpath
  end

  def caveats
    <<~EOS
      To start the server:
        cnosdb-cli
    EOS
  end
  service do
    run bin/"cnosdb"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    environment_variables INFLUXD_CONFIG_PATH: etc/"cnosdb/cnosdb.conf"
  end
  test do
    cnosdb_port = free_port
    cnosdb_host = "localhost"
    cnosdb_http_bind = "http://#{cnosdb_host}:#{cnosdb_port}"
    ENV["CNOSDB_HOST"] = cnosdb_host
    cnosdb = fork do
      exec "#{bin}/cnosdb", "--config", "#{testpath}/config.toml"
      exec "#{bin}/cnosdb-cli", "--host=:#{cnosdb_host}", "--port=#{cnosdb_port}"
    end
    sleep 30
    # Check that the server has properly bundled UI assets and serves them as HTML.
    curl_output = shell_output("curl --silent --head #{cnosdb_http_bind}")
    assert_match "200 OK", curl_output
    assert_match "text/html", curl_output
  ensure
    Process.kill("TERM", cnosdb)
    Process.wait cnosdb
  end
end
