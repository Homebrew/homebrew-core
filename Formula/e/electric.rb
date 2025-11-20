class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.6.tar.gz"
  sha256 "0f347cd18505dfcfdd13c250016bcbe099e8a2468779f4b6800e9bd90965fb18"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "4c82859571ac1ee6eec3bd1ca0f38c30904f4a9c5d6d7892efdb287dcb37f080"
    sha256 cellar: :any,                 arm64_sequoia: "1074d747bb3a2c9a25412f60d00ea744f8bc7629cfc0a71454a07544da45dee3"
    sha256 cellar: :any,                 arm64_sonoma:  "ac48202584404963b0b25a1aa016418b7cc9e84a97a0a426fdc10a46f27f6a10"
    sha256 cellar: :any,                 sonoma:        "e045955d7aa90baad85488ed898a0eca78ff686b3a03b6723b66ec8be1d371ef"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "644711d75055cd629d06aabd82a4681a5911ab0fc56cf9a7db9b7d354dc8ca44"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "bdefe321a12409260b9fe0197e1ad066f1950164c059fb727eefd421b8f38090"
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
