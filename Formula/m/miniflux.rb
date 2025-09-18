class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.12.tar.gz"
  sha256 "76f509778fcf9871416deba7ac1dcf3473747652a027bf4fc217c41d7c973759"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "bb2fbdece6f4662813aaa9d3e69e4e568a6752f1efe8ec904b0e452e91be3460"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "15e21d359066ca87d0dc65cea7f4397def6afea037d8f22d53c1c34dbda5679e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "a31436365c7c49c1c0ff66ec42802f3f4bd16cb953a96a17f2a6f4e03c323556"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "d73fff57817705a0723590bbf606c0bfb6a872e58abac761c86d47edbed10c93"
    sha256 cellar: :any_skip_relocation, sonoma:        "fbc3f55b8de769b5414fadda9ce1b66c551511bb8d58fe2924dea08a1aa095f3"
    sha256 cellar: :any_skip_relocation, ventura:       "222d73ef1037de19407306d89d80eec1f9a3a8e7aad9121010a2d21371ac1b67"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9cdd3ece04ef0f70d911fe8c91c2a1bde552a363adb105158c8cf73d28a4b829"
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
