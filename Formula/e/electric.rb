class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.4.2.tar.gz"
  sha256 "2326cc9b3b13261aa65567a8b0b18c83d531c4d3f2a7d2b98d293c18c40a8975"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "45b9bb6865def1f0783c1760a722f43f44c17555423d918577eddd82c69ce3b9"
    sha256 cellar: :any,                 arm64_sequoia: "bef79f8f909b3dd0da96276d122432a06361a9410863008e50582faef7077f6c"
    sha256 cellar: :any,                 arm64_sonoma:  "506fd6feca2b02621a05ccc5d75ce56114fd457405575ba04af99980452d5ac7"
    sha256 cellar: :any,                 sonoma:        "29a9b2db84b2599ff845ea23729f391c80018cedbbbfcf4fac6d72cb98d5ed4f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "74d8a62265187c4f4dfc1b8620354c8ab5fb997c99358e2ad7f51e7c836eccdf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "9256cbe1b07b3f72cc11452964d6c662b15859290ccaf258105ad6bd5953c8c6"
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
      sleep 5

      output = shell_output("curl -s --retry 5 --retry-connrefused localhost:#{ENV["ELECTRIC_PORT"]}/v1/health")
      assert_match "active", output
    ensure
      system pg_ctl, "stop", "-D", testpath/"test"
    end
  end
end
