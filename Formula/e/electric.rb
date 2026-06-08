class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.6.9.tar.gz"
  sha256 "9432e5a0686b5fb3a90dce08e20e48c556e2e1e283903971015680b4265d9cc8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "2ca7a458be1fc09a232b6afe5185295620cb0f2ef8881d114aa619f41f026ab0"
    sha256 cellar: :any,                 arm64_sequoia: "342ac751c0da46be5baf1308cda357f3be6d454ffe5ba966bb873ed437bd1bde"
    sha256 cellar: :any,                 arm64_sonoma:  "741b6285fe55bdff741378efb14407083cc41290e593fda8064710a9e1b0bde4"
    sha256 cellar: :any,                 sonoma:        "1cb13e7bf205ff2e45f2578ec7340aa516184184154d09a85a78d40dfd1ac310"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "07ee7fab7be4ecf0f3bb1fd3e3a9e8dbfcef7e1f17da4643a1242fa2218698b3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4f6cf1431a69731d45277c65cdefcf4ee6ea98f571093e5525b6db550ea604d8"
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
