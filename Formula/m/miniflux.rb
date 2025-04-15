class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.7.tar.gz"
  sha256 "c412218087a3df9381fe4705ea1681e60ce69c9cbb55acaf425a6d8aa69cd80c"
  license "Apache-2.0"

  depends_on "go" => [:build, :test]
  depends_on "postgresql@17" => ":test"

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
    run opt_bin/"miniflux"
    keep_alive true
    environment_variables LISTEN_ADDR:    "127.0.0.1:8080",
                          DATABASE_URL:   "user=postgres password=postgres dbname=miniflux2 sslmode=disable",
                          RUN_MIGRATIONS: "1"
    error_log_path var/"log/miniflux.log"
    log_path var/"log/miniflux.log"
    working_dir var
  end

  test do
    ENV["LC_ALL"] = "C"
    stable.stage testpath
    pg_bin = Formula["postgresql@17"].opt_bin
    pg_ctl = pg_bin/"pg_ctl"
    datadir = testpath/"postgres"
    system pg_ctl, "initdb", "-D", datadir
    system pg_ctl, "-D", datadir, "start", "-l", testpath/"postgres.log"
    system pg_bin/"createdb", "miniflux_test"
    ENV["DATABASE_URL"] = "postgres:///miniflux_test?sslmode=disable"
    ENV["ADMIN_USERNAME"] = "admin"
    ENV["ADMIN_PASSWORD"] = "test123"
    ENV["CREATE_ADMIN"] = "1"
    ENV["RUN_MIGRATIONS"] = "1"
    ENV["DEBUG"] = "1"
    miniflux_pid = spawn(bin/"miniflux")
    begin
      sleep 5
      ENV["TEST_MINIFLUX_BASE_URL"] = "http://127.0.0.1:8080"
      ENV["TEST_MINIFLUX_ADMIN_USERNAME"] = "admin"
      ENV["TEST_MINIFLUX_ADMIN_PASSWORD"] = "test123"
      system "go", "test", "-v", "-count=1", "./internal/api"
    ensure
      Process.kill 9, miniflux_pid
      Process.wait miniflux_pid
    end
    system pg_ctl, "-D", datadir, "stop"
  end
end
