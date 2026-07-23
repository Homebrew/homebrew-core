class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.7.8.tar.gz"
  sha256 "4ce9bd745d6422b91233ab193c9e8166af8936ccf35f98a24c6e94f244d54d96"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "ec9abd9c9480c99341ce3cf62580e9ea407b0595a14e18decd7532578c2f42ac"
    sha256 cellar: :any, arm64_sequoia: "95ee375a9d7652f9d61ce8f17018b6c533568c09674e81b8cd28a392ddde9b35"
    sha256 cellar: :any, arm64_sonoma:  "7dff2d99912a5059ee3c8e44102dffdf597768fef27835d583663e9827435870"
    sha256 cellar: :any, sonoma:        "9c51b449dca155274605e702e76f316f47972fd11379787bac19bf236f008750"
    sha256 cellar: :any, arm64_linux:   "e4493ff6ac67c462d64475913b649d9df937859cabcf0b0ba5215a13f6accb04"
    sha256 cellar: :any, x86_64_linux:  "13be040e435ddf9133186f154a311ed9c97d364d2b51c0ee376253eb6bfbaa60"
  end

  depends_on "elixir" => :build
  depends_on "erlang@28" => :build # https://github.com/electric-sql/electric/pull/3992
  depends_on "postgresql@18" => :test
  depends_on "openssl@3"

  uses_from_macos "ncurses"

  on_linux do
    depends_on "zlib-ng-compat"
  end

  def install
    ENV["MIX_ENV"] = "prod"
    ENV["MIX_TARGET"] = "application"

    cd "packages/sync-service" do
      system "mix", "deps.get"
      system "mix", "compile"
      system "mix", "release", "--path", libexec
      bin.write_exec_script libexec.glob("bin/*")
    end
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    postgresql = Formula["postgresql@18"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
    ENV["ELECTRIC_INSECURE"] = "true"
    ENV["ELECTRIC_PORT"] = free_port.to_s
    ENV["LC_ALL"] = "C"
    ENV["PGDATA"] = testpath/"test"

    system pg_ctl, "initdb", "--options=-c port=#{port} -c wal_level=logical"
    system pg_ctl, "start", "-l", testpath/"log"

    begin
      (testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups").mkpath

      spawn bin/"electric", "start"
      sleep 5 if OS.mac? && Hardware::CPU.intel?

      tries = 0
      begin
        output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
        assert_match "active", output
      rescue Minitest::Assertion
        # https://github.com/electric-sql/electric/blob/main/website/docs/guides/deployment.md#health-checks
        raise if !output&.match?(/starting|waiting/) || (tries += 1) >= 3

        sleep 10
        retry
      end
    ensure
      system pg_ctl, "stop"
    end
  end
end
