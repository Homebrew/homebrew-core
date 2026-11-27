class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-5.2.1.tgz"
  sha256 "a25fde87ae5e7b3ed1cfd70e3f757be04c009c9f188febc497b948513d39bba0"
  license "MIT"

  bottle do
    manifest_sha256 "985f1ebc3a9650f2aefaed515ce1c7ba1b1aee445ec29a460081947e54891daf"
    sha256 cellar: :any_skip_relocation, all: "48679831f7c718e8ee98c68a562ec8451e95776806eb94eb6edfc8c4b6a6617d"
  end

  depends_on "postgresql@19" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    ENV["LC_ALL"] = "C"
    ENV["GRAPHILE_ENV"] = "development"
    ENV["PGDATA"] = testpath/"test"
    ENV["PGHOST"] = testpath.to_s
    ENV["PGPORT"] = free_port.to_s
    pg_bin = dep("postgresql").opt_bin
    pg_ctl = pg_bin/"pg_ctl"

    assert_match version.to_s, shell_output("#{bin}/postgraphile --version")

    system pg_ctl, "initdb", "--options=-c unix_socket_directories=#{testpath}"
    system pg_ctl, "start", "--log=#{testpath}/log"
    begin
      system pg_bin/"createdb", "mydb"

      preset = "postgraphile/presets/amber"
      port = free_port.to_s
      query = { query: "{ __typename }" }.to_json
      with_test_process(bin/"postgraphile", "--connection", "postgres:///mydb", "--preset", preset, "--port", port) do
        output = shell_output("curl --silent --show-error --fail --retry 5 --retry-connrefused --retry-delay 1 " \
                              "--header 'Content-Type: application/json' --data '#{query}' " \
                              "http://localhost:#{port}/graphql")
        assert_equal "Query", JSON.parse(output).dig("data", "__typename")
      end
    ensure
      system pg_ctl, "stop"
    end
  end
end
