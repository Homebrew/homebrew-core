class Cnosdb < Formula
  desc "Open source distributed time series database"
  homepage "https://www.cnosdb.com"
  url "https://github.com/cnosdb/cnosdb.git",
      tag:      "v1.0.2",
      revision: "bf128f15334a9104a5a644917693c29bf5eb3e65"
  license "MIT"
  head "https://github.com/cnosdb/cnosdb.git", branch: "main"

  # The regex below omits a rogue `v9.9.9` tag that breaks version comparison.
  livecheck do
    url :stable
    regex(/^v?((?!9\.9\.9)\d+(?:\.\d+)+)$/i)
  end

  depends_on "go" => :build

  def install
    ldflags = %W[
      -s
      -w
      -X main.version=#{version}
      -X main.commit=#{Utils.git_short_head(length: 10)}
      -X main.date=#{time.iso8601}
    ]
    %w[cnosdb cnosdb-cli cnosdb-inspect cnosdb-tools cnosdb-ctl cnosdb-meta].each do |cmd|
      system "go", "build", *std_go_args(output: bin/cmd, ldflags: ldflags), "./cmd/#{cmd}"
    end
    exec "pwd"
    inreplace "#{HOMEBREW_PREFIX}/etc/config.sample.toml" do |s|
      s.gsub! "/var/lib/cnosdb/data", "#{var}/cnosdb/data"
      s.gsub! "/var/lib/cnosdb/meta", "#{var}/cnosdb/meta"
      s.gsub! "/var/lib/cnosdb/wal", "#{var}/cnosdb/wal"
    end
    etc.install "#{HOMEBREW_PREFIX}/etc/config.sample.toml" => "cnosdb.conf"
    (var/"cnosdb/data").mkpath
    (var/"cnosdb/meta").mkpath
    (var/"cnosdb/wal").mkpath
  end

  service do
    run bin/"cnosdb"
    keep_alive true
    working_dir HOMEBREW_PREFIX
    environment_variables CNOSDB_CONFIG_PATH: "#{HOMEBREW_PREFIX}/etc/cnosdb.conf"
  end

  test do
    cnosdb_port = free_port
    cnosdb_host = "localhost"
    (testpath/"cnosdb.conf").write shell_output("#{bin}/cnosdb config")
    inreplace testpath/"cnosdb.conf" do |s|
      s.gsub! %r{/.*/.cnosdb/data}, "#{testpath}/cnosdb/data"
      s.gsub! %r{/.*/.cnosdb/meta}, "#{testpath}/cnosdb/meta"
      s.gsub! %r{/.*/.cnosdb/wal}, "#{testpath}/cnosdb/wal"
    end
    begin
      cnosdb = fork do
        exec "#{bin}/cnosdb-cli", "--host=#{cnosdb_host}", "--port=#{cnosdb_port}"
      end
      sleep 30
      # Assert that initial resources show in CLI output.
      assert_match "CnosDB v1.0.2 (git: unknown bf128f1533)", shell_output("#{bin}/cnosdb version")
    ensure
      Process.kill("SIGTERM", cnosdb)
      Process.wait(cnosdb)
    end
  end
end
