class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.6.2.tar.gz"
  sha256 "67fa27d1265114a1047ac29d8a75da6cfed78f40d5872d1822a0bbe7f17d958c"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any, arm64_tahoe:   "c92f761a6a6863af06999fb985d1e56dc3fc791a3d0e469fd80e2335fe39efac"
    sha256 cellar: :any, arm64_sequoia: "d8cf2fdab60eb48f6b7cebe47d2ceddf568a1b7990ec06b30cbb35fa9409644c"
    sha256 cellar: :any, arm64_sonoma:  "bcc9814e843915518be4f6204aec9b3563692794ca9730f74efcc8cc904478b9"
    sha256 cellar: :any, sonoma:        "01cfd5ab8b502ae69421cb6e223784e6faa4312732e9581f871140ee18cc7dd0"
    sha256               arm64_linux:   "e31cbee884af4fe1c81762686156489eb56e87118d1cace9dcb42b9c21141e54"
    sha256               x86_64_linux:  "a42a3d0b1996341e63afb9c6083f98c00f382704744909256e6f426fac3dd8bc"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@18" => :test
  depends_on "erlang"
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
      system "mix", "release"
      libexec.install Dir["_build/application_prod/rel/electric/*"]
      bin.write_exec_script libexec.glob("bin/*")
    end

    # Remove non-native libraries
    os = OS.kernel_name.downcase
    arch = Hardware::CPU.intel? ? "amd64" : Hardware::CPU.arch
    libexec.glob("lib/ex_sqlean-0.8.8/priv/*").each do |f|
      rm_r(f) unless f.basename.to_s.match?("#{os}-#{arch}")
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
