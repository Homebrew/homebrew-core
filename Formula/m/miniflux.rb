class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.19.tar.gz"
  sha256 "1c88cd40f5deff94aab9ac1722b7b0f358e473a5d0974cdd5ce258e3ac2113f0"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "58dcca6ebec0995dea621ac429e45206ce4c7c3055a99b1cde5e31d868355b7a"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "30792edd7c670e5dab453fbaf438804663751812196ceffe44b71baa5953610d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "ddca71208b219c55d745aa7906a61695b329b18158baf6f57a74dfd4bf7464a9"
    sha256 cellar: :any_skip_relocation, sonoma:        "cf9a595acf2ec92dd340722145cb6963ed269b35599c4226e713442f871f93ff"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "80097f490f8178387c68e9b09f9792f4cb0e720ca56723ef3d0f3101ba2f5d00"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fd8b9982881ab0c9991d5aa2e9d17c52a7d1d7b241531d875d197f5690a6b72a"
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
