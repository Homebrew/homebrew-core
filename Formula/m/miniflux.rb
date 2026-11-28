class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.3.5.tar.gz"
  sha256 "1cd7bf4b2cf4a366271ee6cfa5994de3337fb13dc934d0eaf02e4b67839828d2"
  license "Apache-2.0"

  bottle do
    manifest_sha256 "5bf6087457cbbb841a904d8feb298cda1839fe17369b2ed5e7d8b16053097999"
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "5a44552fdb0f0b6b0c92865ea94cf5b297eab909218148e07b454ea8998624e4"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "2c794922821c04733b17a800e6a6071e2f921dcc0f05b855e81eaccd86a3e0c9"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "4c3e1546f0bdb42d0d5f2ee8bab480399a313c1340509a47f4a0d2930acf4937"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "47113d5c39542115150b973a3f09e4112f1c0ef710269914e0e25b68308dc45a"
    sha256 cellar: :any,                 x86_64_linux:      "be77c79aeb62b09d944d9c8bbea6aaafef8822636d6f9640c201d53aa674e15f"
  end

  depends_on "go" => :build
  depends_on "postgresql@19" => :test

  allow_network_access! :test

  def fetch
    system "go", "mod", "download"
  end

  def install
    ldflags = %W[
      -X miniflux.app/v2/internal/version.Version=#{version}
      -X miniflux.app/v2/internal/version.Commit=#{tap.user}
      -X miniflux.app/v2/internal/version.BuildDate=#{time.iso8601}
    ]
    system "go", "build", *std_go_args(ldflags:)
  end

  service do
    run [opt_bin/"miniflux", "-c", etc/"miniflux.conf"]
    keep_alive true
    error_log_path var/"log/miniflux.log"
    log_path var/"log/miniflux.log"
    working_dir var
  end

  test do
    ENV["LC_ALL"] = "C"
    ENV["PGDATA"] = datadir = testpath/"postgres"

    miniflux_addr = "127.0.0.1:#{free_port}"
    pg_port = free_port
    pg_bin = dep("postgresql").opt_bin
    pg_ctl = pg_bin/"pg_ctl"

    (testpath/"miniflux.conf").write <<~CONF
      DATABASE_URL=postgres://localhost:#{pg_port}/miniflux_test?sslmode=disable
      ADMIN_USERNAME=admin
      ADMIN_PASSWORD=test123
      CREATE_ADMIN=1
      RUN_MIGRATIONS=1
      LOG_LEVEL=debug
      LISTEN_ADDR=#{miniflux_addr}
    CONF

    system pg_ctl, "init", "--options=-c port=#{pg_port} -c unix_socket_directories=#{datadir}"
    system pg_ctl, "start", "--log=#{testpath}/postgres.log"
    begin
      system pg_bin/"createdb", "-h", datadir, "-p", pg_port.to_s, "miniflux_test"
      miniflux_pid = spawn(bin/"miniflux", "-c", testpath/"miniflux.conf")
      output = shell_output("curl --silent --retry 5 --retry-connrefused http://#{miniflux_addr}/healthcheck")
      assert_equal "OK", output
    ensure
      if miniflux_pid
        Process.kill "TERM", miniflux_pid
        Process.wait miniflux_pid
      end
      system pg_ctl, "stop"
    end
  end
end
