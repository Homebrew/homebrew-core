class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.3.3.tar.gz"
  sha256 "68cd4f16d85faf2045c13990de605cc7b1e2550d7a1d88e3522d2893685b5847"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "55ba97e4c1e63b303b8c0ee564d09a5cec19e50dc496f383c965df9f91f20d09"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6644bbd31fe23073166473f48a65b2d7ec9ca551a5aecafad8853a040fe1c696"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "71bf060d7fd89a9144422561765b34f7413b8d46bba06cc70f6be7c8e2ebd67b"
    sha256 cellar: :any_skip_relocation, sonoma:        "1fe07016bea56ae7e183995da49e8b01d4e24aeeeda3bc3f05584b25a1ccdf0f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "f8e0cf7f18d0ad1414d6d33f1ec5db810655bb0726742dbc6cbb8bcb13b9d133"
    sha256 cellar: :any,                 x86_64_linux:  "012c3d315c902ca94d0423001c80ab55be480777f64dc26a1b9a1370afa5ba7d"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test

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

    pg_port = free_port
    pg_bin = formula_opt_bin("postgresql@18")
    pg_ctl = pg_bin/"pg_ctl"

    datadir = testpath/"postgres"
    system pg_ctl, "init", "-D", datadir

    (datadir/"postgresql.conf").write <<~EOS, mode: "a+"
      port = #{pg_port}
      unix_socket_directories = '#{datadir}'
    EOS

    system pg_ctl, "start", "-D", datadir, "-l", testpath/"postgres.log"
    begin
      system pg_bin/"createdb", "-h", datadir, "-p", pg_port.to_s, "miniflux_test"

      # Run Miniflux
      miniflux_port = free_port
      (testpath/"miniflux.conf").write <<~CONF
        DATABASE_URL=postgres://localhost:#{pg_port}/miniflux_test?sslmode=disable
        ADMIN_USERNAME=admin
        ADMIN_PASSWORD=test123
        CREATE_ADMIN=1
        RUN_MIGRATIONS=1
        LOG_LEVEL=debug
        LISTEN_ADDR=127.0.0.1:#{miniflux_port}
      CONF

      miniflux_pid = spawn(bin/"miniflux", "-c", testpath/"miniflux.conf")
      begin
        assert_equal "OK",
          shell_output("curl --silent --retry 5 --retry-connrefused http://127.0.0.1:#{miniflux_port}/healthcheck")
      ensure
        Process.kill "TERM", miniflux_pid
        Process.wait miniflux_pid
      end
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
