class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.16.tar.gz"
  sha256 "b6d015c3c73368425ac8e01fb67c98ae3e998a962a268cd956f57b1c8b023e17"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e0e604060caeac4990db89d40b142839643f63dba6905f74788adfc299db9ab6"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "667cd2604ce2fa4f6e68a8c370fd43ee9ccd41947e5a15279e4360ca3d576cf4"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "27b75d2d8d84c4b17e0b614178958c638e0c7fa5db309d8242e64b290b698bee"
    sha256 cellar: :any_skip_relocation, sonoma:        "7fa06e8b505ea480acc4321b55beb2e41fedb5d6a36743bc3ed5575cf833b488"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "9ca488d1390bd89672b10930eb3166f790aab0f5b33d7e1858ca4fcfa6a66a13"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "293cdb8d4694f1c0c9d2430194aecc9c50efee104dc7273f1c00f4d6ee770ff5"
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
