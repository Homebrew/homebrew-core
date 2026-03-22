class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.18.tar.gz"
  sha256 "1d8307872f648937b6108286840fb3785171cc4a2b97454f76fcf8751c382f4f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9db83481ac4e7e3b8293a1ddcdb746c71843f207c16fb96c28d4966bd0891ddf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "597f28594a5db6390a2c3ed26bb8b3ad9c0eb227ec97707ded49aa6f0d0563fc"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "be60d8f4c7b57537555be7817615ba00aee61fbb03522c0a063706111188bb11"
    sha256 cellar: :any_skip_relocation, sonoma:        "ca5a89a929b53e40e460bc23a4a09fb54b8ad663bbc3a5523f1f2990dc437f64"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "678af950f96d918fc29cbcfb56ac5e024c5ba24096d37f75580ebb421e4e4076"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "46b99a3d41cde1dd598a344cffe6435b4f5de8572d0f7cac4a7bd7a6df02c02d"
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
