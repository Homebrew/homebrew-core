class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.3.2.tar.gz"
  sha256 "5bcfab4ca5c8d3ab83627d7230129fc616c98e5050f475f2876995441b2fc94e"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "8bcfb9a1d8fc28f48fce1990ef484e6c87b215bef0b6ee51c76f50301d6eafa2"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "8aa8c1cc5ba57fb5d36423c717a1a1258aebdbd953afb4ec8a8e3fa3d7977c26"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "694dc36507e595f0f4a3d84704b5895090fe56b48c3be8700c80690197d628a6"
    sha256 cellar: :any_skip_relocation, sonoma:        "38e8fa22565ac5912ec985b2010fa99c18b167ed737827b26bada9b148bc3ca3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "7c48b429174fc224fad68966a25aea0e47abe85969ebc431968afcc19bb38a43"
    sha256 cellar: :any,                 x86_64_linux:  "b334827b8901c86b247578a5f3444b42727c95658f98f6fcdea44a853dc89487"
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
