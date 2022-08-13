require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema 🐘"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.12.11.tgz"
  sha256 "553191171d304b35846d8fc8c40beace5649f85982d4363da13b992fd2aad3d3"
  license "MIT"
  revision 1
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fb2b7fc86011d7f6262bb40919faff5180008ffd80b908f22c969bd828df7849"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fb2b7fc86011d7f6262bb40919faff5180008ffd80b908f22c969bd828df7849"
    sha256 cellar: :any_skip_relocation, monterey:       "13ca030630db036b5e9b28231f9c542800f78951c7619f9c5bd6e83c5060a546"
    sha256 cellar: :any_skip_relocation, big_sur:        "13ca030630db036b5e9b28231f9c542800f78951c7619f9c5bd6e83c5060a546"
    sha256 cellar: :any_skip_relocation, catalina:       "13ca030630db036b5e9b28231f9c542800f78951c7619f9c5bd6e83c5060a546"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fb2b7fc86011d7f6262bb40919faff5180008ffd80b908f22c969bd828df7849"
  end

  depends_on "postgresql" => :test
  depends_on "libpq"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql"].opt_bin
    system "#{pg_bin}/initdb", "-D", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres", "-D", testpath/"test")
    end

    begin
      sleep 2
      system "#{pg_bin}/createdb", "test"
      system "#{bin}/postgraphile", "-c", "postgres:///test", "-X"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
