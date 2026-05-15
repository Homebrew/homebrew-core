class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.0.2.tgz"
  sha256 "12109bb851bfa48be7219dd93df1a08c74cb1adc82d44d9a1bdc3fe7d8ef3a43"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "5daab44c23c0aab051c2a74c0bfa8ef37f3c09a02714f3779e1c30d999994b66"
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
