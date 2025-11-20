class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.14.tar.gz"
  sha256 "8cc9beadb74ac592dbb2d325500429c4ec95b21857773c16f8685ef7b9b807c1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7b82221cc40e1c68c94c4b6f265f8425fa7c69709f90f221766df19e1defcb1a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "7703987c502c0c8f022a708c4be247e24a710f8a6fa4daea3a915d189d3d46fd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "90598590982077cfd2aa32f22eace850884b60cc409aa8e02801f6ce196cf35b"
    sha256 cellar: :any_skip_relocation, sonoma:        "ea27907aa4d23ddd0c648103a6512cc805833ead6033f63f2496e56a7be99725"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "0bde792defd1183f1593f7785e12008364190c6f2a4aa2a5c1afd48d5cf16edb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "b89bd7d296056fc6796ef7863ed59f1a00d09b3792fa097c79827b89372f226f"
  end

  depends_on "go" => :build
  depends_on "postgresql@18" => :test

  def install
    ldflags = %W[
      -s -w
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
    pg_bin = Formula["postgresql@18"].opt_bin
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
        sleep 2
        assert_equal "OK", shell_output("curl -s http://127.0.0.1:#{miniflux_port}/healthcheck")
      ensure
        Process.kill "TERM", miniflux_pid
        Process.wait miniflux_pid
      end
    ensure
      system pg_ctl, "stop", "-D", datadir
    end
  end
end
