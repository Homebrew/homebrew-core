class Cnosdb < Formula
  desc "Open source distributed time series database"
  homepage "https://www.cnosdb.com"
  url "https://github.com/cnosdb/cnosdb/archive/refs/tags/v1.0.2.tar.gz"
  sha256 "ae412d0944b64c9b39dc1edc66f7b6f712b85bc5afad354c12b135ae71017100"
  license "MIT"
  head "https://github.com/cnosdb/cnosdb.git", branch: "main"
  depends_on "go" => :build
  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]

    system "go", "build", *std_go_args(output: bin/"cnosdb", ldflags: ldflags), "./cmd/cnosdb"
    system "go", "build", *std_go_args(output: bin/"cnosdb-cli", ldflags: ldflags), "./cmd/cnosdb-cli"
    system "go", "build", *std_go_args(output: bin/"cnosdb-inspect", ldflags: ldflags), "./cmd/cnosdb-inspect"
    system "go", "build", *std_go_args(output: bin/"cnosdb-tools", ldflags: ldflags), "./cmd/cnosdb-tools"
    system "go", "build", *std_go_args(output: bin/"cnosdb-ctl", ldflags: ldflags), "./cmd/cnosdb-ctl"
    system "go", "build", *std_go_args(output: bin/"cnosdb-meta", ldflags: ldflags), "./cmd/cnosdb-meta"
    inreplace birthpath "etc/config.sample.toml" do |s|
      s.gsub! "/var/lib/cnosdb/data", "#{var}/cnosdb/data"
      s.gsub! "/var/lib/cnosdb/meta", "#{var}/cnosdb/meta"
      s.gsub! "/var/lib/cnosdb/wal", "#{var}/cnosdb/wal"
    end
    bin.install "bin/cnsodb"
    bin.install "bin/cnosdb-cli"
    bin.install "bin/cnosdb-inspect"
    bin.install "bin/cnosdb-meta"
    bin.install "bin/cnosdb-tools"
    etc.install birthpath "etc/config.sample.toml" => "cnosdb.conf"
    (var/"cnosdb/data").mkpath
    (var/"cnosdb/meta").mkpath
    (var/"cnosdb/wal").mkpath
  end
  test do
    cnosdb_port = free_port
    (testpath/"config.toml").write shell_output("#{bin}/cnosdb config")
    inreplace testpath/"config.toml" do |s|
      s.gsub! %r{/.*/.cnosdb/data}, "#{testpath}/cnosdb/data"
      s.gsub! %r{/.*/.cnosdb/meta}, "#{testpath}/cnosdb/meta"
      s.gsub! %r{/.*/.cnosdb/wal}, "#{testpath}/cnosdb/wal"
    end
    begin
      pid = fork do
        exec bin/"cnosdb", "--config", testpath/"config.toml"
      end
      sleep 60
      output = shell_output("curl -Is localhost:#{cnosdb_port}/ping")
      assert_match output
    ensure
      Process.kill("SIGTERM", pid)
      Process.wait(pid)
    end
  end
end
