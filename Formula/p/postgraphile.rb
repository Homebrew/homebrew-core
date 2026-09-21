class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.1.5.tgz"
  sha256 "4396f2de8482b3b31d90074c12b4804ba40d5b49ee8a7b32380a889953aa9bb9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "b9dfda85997743e3a4dc89ea998f57c784ef6b9c29700df83d75e51f13aab50c"
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
    ENV["PGHOST"] = testpath.to_s
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = formula_opt_bin("postgresql@18")
    system pg_bin/"initdb", "-D", testpath/"test"
    pid = spawn("#{pg_bin}/postgres", "-D", testpath/"test", "-k", testpath, "-h", "")

    begin
      sleep 2
      system pg_bin/"createdb", "test"

      preset = libexec/"lib/node_modules/postgraphile/dist/presets/amber.js"
      port = free_port
      graphite_pid = spawn bin/"postgraphile", "-c", "postgres:///test?host=#{testpath}",
                          "--preset", preset, "--port", port.to_s
      query = { query: "{ __typename }" }.to_json
      output = shell_output("curl --silent --show-error --fail --retry 5 --retry-connrefused --retry-delay 1 " \
                            "--header 'Content-Type: application/json' --data '#{query}' " \
                            "http://localhost:#{port}/graphql")
      assert_equal "Query", JSON.parse(output).dig("data", "__typename")
    ensure
      Process.kill("TERM", graphite_pid)
      Process.wait(graphite_pid)
    end
  ensure
    Process.kill("TERM", pid)
    Process.wait(pid)
  end
end
