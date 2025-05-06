class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.8.tar.gz"
  sha256 "1c360012c3dd0202601db26755c511969b6c527f96d6829861a74095633a35c2"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1e0d27dd1fef8dcdcd23598be51cc9819419419c84b62a62bf0b97d28db08b70"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "45f578e2d4597071549c305ffeced5dc3e364ff171c28d365d253ec891e32bcd"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "042c119283d08ce163e03ed113287b3da869ec3c2f9dd9b29d553b2b2c9155ab"
    sha256 cellar: :any_skip_relocation, sonoma:        "1697fb84642eeaed22e169595f8ae33fe18126d7d8121ad9278eaebff95b7137"
    sha256 cellar: :any_skip_relocation, ventura:       "39e5e3f7701a0bb7dff79506a00c95958e79b0afd0c02f8c857cc3918e820305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "be8b87cc40ab4b80182e3041936b2cf60de72623149b6cd216f3e5eeeff2c592"
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
