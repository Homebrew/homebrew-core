class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.10.tar.gz"
  sha256 "a216b93a32d14a7a6ca48fd7f5e86b8a4e8c58b1bf5d83fc4d3aacaaaf4e6a48"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "73c7700e6bf7c97e4bdaa1e71560fcb4d6462bacb8b869ef2c75e22ff5288abb"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8fd3fd2d04afcf389b8f42b26e7fff391ff776568d03dec75e9c598deb16a613"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "dc225270a44cb83ff3e341a040d53bb81d8b6889c5752e5941d92cfc0fbcd3c9"
    sha256 cellar: :any_skip_relocation, sonoma:        "5bc0244eebc8f1ecd36060c4104b8f10c12e155228ef7ec473289647059b7d92"
    sha256 cellar: :any_skip_relocation, ventura:       "b5b7c1a0ca639f4e556c8c516ad96ca436a3683e2ef3775284698f2c544cc6a6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f843ee457b16e434832cb4ec5fd06c4e28976e608944a103f906422d0d44b2a8"
  end

  depends_on "go" => :build
  depends_on "postgresql@17" => :test

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
    pg_bin = Formula["postgresql@17"].opt_bin
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
