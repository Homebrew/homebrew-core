class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.1.4.tgz"
  sha256 "e9f2c308a60f5e0cd26846c07281e19a8ad7de206f7e4a0315723d7e598951bf"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5686a86ae1dba781a1ba667f627aa39effc797595953d73b7e14c4d35fcde2a7"
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

    pg_bin = formula_opt_bin("postgresql@18")
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
