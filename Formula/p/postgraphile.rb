class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.0.3.tgz"
  sha256 "54fae2ac32e94c0fcb8be9771f107b9c412e8b0d7a4898115bdce29ea8cb5ae8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "3ec054ffea18482d46af359cc3b6a95ec5944b4cf2d00681bc856ab54a921bdb"
  end

  depends_on "postgresql@18" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["LC_ALL"] = "C"
    ENV["GRAPHILE_ENV"] = "development"
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql@18"].opt_bin
    system pg_bin/"initdb", "-D", testpath/"test"
    pid = spawn("#{pg_bin}/postgres", "-D", testpath/"test")

    begin
      sleep 2
      system pg_bin/"createdb", "test"

      preset = libexec/"lib/node_modules/postgraphile/dist/presets/amber.js"
      graphite_pid = spawn bin/"postgraphile", "-c", "postgres:///test", "--preset", preset
      sleep 3
    ensure
      Process.kill("TERM", graphite_pid)
      Process.wait(graphite_pid)
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
