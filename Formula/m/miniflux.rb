class Miniflux < Formula
  desc "Minimalist and opinionated feed reader"
  homepage "https://miniflux.app"
  url "https://github.com/miniflux/v2/archive/refs/tags/2.2.9.tar.gz"
  sha256 "7735912fbb232fd588f16528ead4b3a7e5bd02688827120316ba5c60f5fc0bcd"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "a844a312744c03a5fc807eb5e040f967997283789da0dd6815b0859edf5cb8bd"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "7aeb636b8ac11847dc819d8e503b8e37656cf17e867c6790b13666963277b049"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "4d2d504906c6f36a3ecb38389c746ad5895b3d537a419daf66741132f4b82909"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2ee9be699f5b904675e54e9b7b1804d986182bf3c8763a995b1c4758bd51432"
    sha256 cellar: :any_skip_relocation, ventura:       "9f0a2d1527eba1f1cd850f3789ef0e382e8cba4ef2d5f983c7dc8a80e9baf46a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "e5d0528805e324b3c2139ff5079622e325c1751283b2c8744afee84263bcaa93"
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
