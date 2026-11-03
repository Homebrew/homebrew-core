class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.2.1.tgz"
  sha256 "a25fde87ae5e7b3ed1cfd70e3f757be04c009c9f188febc497b948513d39bba0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, all: "48679831f7c718e8ee98c68a562ec8451e95776806eb94eb6edfc8c4b6a6617d"
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
