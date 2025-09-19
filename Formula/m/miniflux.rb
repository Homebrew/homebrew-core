class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.13.tar.gz"
  sha256 "fc7e374162f5cbb2ff208191ded681a61d3faa2572a45ecf586364316f8d7456"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "88bb3f25bd0634fd3c861065038c01ecbe4c9e9d247b759eb784ce55bea1b4e5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "4726431e2f652754e5c23d0e787e14e5e7217ba812af1f005cbd5f8068ea079e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c9287991981a9b470476c7156c2b4424adb32a80efd053597167000f12e6cc5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "ec0f5f048b8401fa95cbc1dcd6ce770c99b280da32d31739dd5daf97463dc884"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5fa63ea605666ca80d09c27f44991e2b8df660d7a6423a5675fdeb1c90f929f9"
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
