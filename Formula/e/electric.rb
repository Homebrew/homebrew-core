class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.8.1.tar.gz"
  sha256 "2ba074fb3de684b611d1297fd9ae44b435f1bb9fd0774b3a451a224832f8ed97"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    rebuild 1
    sha256 cellar: :any, arm64_golden_gate: "84678fff7153f36807c3a80071fb73230d87c3099a070550497a668479871c1a"
    sha256 cellar: :any, arm64_tahoe:       "5c504225e9f608cc2add83506a75884851019564604aecb436cbcc38c2fd1e9a"
    sha256 cellar: :any, arm64_sequoia:     "888df4a0e5f45817c73f3f3346c46584ef49ca9eebf9cee3cca7eeb6246d41de"
    sha256 cellar: :any, arm64_linux:       "85b55caad2c131e3c706bf02761677b280eb2e8b3ceebba4e214a3b9f121084a"
    sha256 cellar: :any, x86_64_linux:      "ec646d80efb17aa62c67ac0ef88d57e91dc9840a7dae1f697eb8db86b9ef1864"
  end

  depends_on "elixir" => :build
  depends_on "erlang" => :build
  depends_on "postgresql@18" => :test
  depends_on "openssl@4"

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
