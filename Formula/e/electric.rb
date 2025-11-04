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
    sha256 cellar: :any,                 arm64_tahoe:   "a813e9af8e8c73f8118623debd92fd944f43c3183454aeb61a2b2da7a554622a"
    sha256 cellar: :any,                 arm64_sequoia: "fec8f7c5c0fbbf0fd732165f0bd33521bf73107762210469092fef3fc70c525c"
    sha256 cellar: :any,                 arm64_sonoma:  "6f23919d31a659140a706c44cd6b27e85cb5c98877ef64138dc6dc51a98a33ad"
    sha256 cellar: :any,                 sonoma:        "96d30edeab660d3e05c26daa4a618683d7b0b7b05243677ffa3c40f945fe54e6"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "504c3c98ad33d0c5651776cfbd16c6dc714775a5743d02349f4552d66ecd73f6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "7fdfabe82d82f29a895d367aa1c3581a13dda54db33a6991236e33f51963bd4e"
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
