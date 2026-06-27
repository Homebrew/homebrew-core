class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.3.1.tar.gz"
  sha256 "2cf82b224aba61dd8dddd60d7e850d3fdd06c1eaf4f1572aabb0818ec0a95ff2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5414263ec3f4bf77de02a44ab99ec1c4b3f824751d3de9b0f687818bfb0e3b2b"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "cc2e7d08b424b0de6e9347859c85743362029974f99c283473e86465172642be"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "9a935ffd0b1b451179a393456a17fdcf22d9ff6680aa398e3d6b0aa51dbf8980"
    sha256 cellar: :any_skip_relocation, sonoma:        "0dbe15c16dd32595bfc2306707c4997dd1af1745a0c51c93acb1ce4c95d2a8da"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "4563bd95ea033f2ff4c06c9d7b8b639a4f3bde7e0360668e5dfaeb36edbd070c"
    sha256 cellar: :any,                 x86_64_linux:  "0f1ab61c3f02b54b127b575954e8138547f3adfa718fe10cf1ac6fc2c770bcb4"
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
