class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.17.tar.gz"
  sha256 "06cee3802e3534d6c05e6f35762141433b06b43d21b91f463e708696606803e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "30b90cdd56f930cf376c0358c71dbe858bc546718718dbc3b0cc018d69dc24b5"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "06d5ddf52f4185b1a40b398636c558d0ded8bf39e640ceabfc66762eb451ecd7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dd23d929b6a99c2bf57927bc1a9218a6582b015ee96f164a1fbc1aadf1ee9066"
    sha256 cellar: :any_skip_relocation, sonoma:        "b5f18d20e0d7cb1131413c601b8afc9a37aac96014ed937bd6499aa09b963faf"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "71831293ea409bdb7d743f7e7844837e750cb4fd2364d8b546392594e1ff6418"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4539765daf20c6e77048430702ec309dcec7fd712971afa654830c5990040c86"
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
