class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.3.tar.gz"
  sha256 "84ae1984f7491968d625d126bdb98089ff068f4fe6fe8a2e924fca476de43948"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "85ed13630c7552d67ae01d7e0436371863942162d903c9e9108bbf39ada0ee30"
    sha256 cellar: :any,                 arm64_sequoia: "72f245ad01140349e56c1cde54b48837e87371865194be47acc03bdd179d4319"
    sha256 cellar: :any,                 arm64_sonoma:  "3285882ee44db943895a39f4c7c866a858c940852f0c0ead278e2d855ace2d88"
    sha256 cellar: :any,                 sonoma:        "5f310bfa41c1deff63d96346ff9a145ed3b00789b8bcfe724fb5e35407412d41"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "5ef0dfff370e8a7a4efdf2b8c90f62ece04369add30dcb638f1e96e2ca62ce4b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "380bbee0b2b612b660387897541e9092f9a788b2a3ef406557c7c82135397a81"
  end

  depends_on "elixir" => :build
  depends_on "postgresql@17" => :test
  depends_on "erlang"
  depends_on "openssl@3"

  uses_from_macos "ncurses"
  uses_from_macos "zlib"

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
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/electric version")

    ENV["LC_ALL"] = "C"

    postgresql = Formula["postgresql@17"]
    pg_ctl = postgresql.opt_bin/"pg_ctl"
    port = free_port

    system pg_ctl, "initdb", "-D", testpath/"test"
    (testpath/"test/postgresql.conf").write <<~EOS, mode: "a+"
      port = #{port}
      wal_level = logical
    EOS
    system pg_ctl, "start", "-D", testpath/"test", "-l", testpath/"log"

    begin
      ENV["DATABASE_URL"] = "postgres://#{ENV["USER"]}:@localhost:#{port}/postgres?sslmode=disable"
      ENV["ELECTRIC_INSECURE"] = "true"
      ENV["ELECTRIC_PORT"] = free_port.to_s

      mkdir_p testpath/"persistent/shapes/single_stack/.meta/backups/shape_status_backups"

      spawn bin/"electric", "start"

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
