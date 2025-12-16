class Electric < Formula
  desc "Real-time sync for Postgres"
  homepage "https://electric-sql.com"
  url "https://github.com/electric-sql/electric/archive/refs/tags/@core/sync-service@1.2.9.tar.gz"
  sha256 "e1a54f10d0fc7d935a70634db7d2ba0ed6ed64dac4cd312edf9d2becb99d728d"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(%r{^@core/sync-service@(\d+(?:\.\d+)+)$}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "32c9e8c6bc4112db70ab58f43501c9b8fec388e9b35fb65b1f3bca23cfb5ad0c"
    sha256 cellar: :any,                 arm64_sequoia: "6aef79637e37c0f27ff8d77d1499d46a7fb87ca9de374098d98fcc09b9cbd304"
    sha256 cellar: :any,                 arm64_sonoma:  "4e966f730e427fa5c79b526de19db5baff6932e6d89761b3aa2eb6f6d587db14"
    sha256 cellar: :any,                 sonoma:        "2568ce88c83cd9fd2bc387a44d265f7496c300c81c4a2d44452df8820368fc0d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "463e94bffe03cefe8a660e31922eda6295f1595dacff47db05815e5a5b2859ce"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f135fc91da0b20ef126959ff386557d9e36a59c2d2d6364ee014436c2ff2d6b0"
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
