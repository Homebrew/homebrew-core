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
  end
  test do
    pid = fork do
      exec "#{bin}/cnosdb --config #{HOMEBREW_PREFIX}/etc/cnosdb.conf"
    end
    sleep 6
    output = shell_output("curl -Is localhost:8086/ping")
    assert_match X-cnosdb-Version, output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
  end
end
