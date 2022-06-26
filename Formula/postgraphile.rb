require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema 🐘"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.12.11.tgz"
  sha256 "553191171d304b35846d8fc8c40beace5649f85982d4363da13b992fd2aad3d3"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "079f749387e1b4e48a548f89be058aeb148633e8dfa4b52033a2240c63109920"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "079f749387e1b4e48a548f89be058aeb148633e8dfa4b52033a2240c63109920"
    sha256 cellar: :any_skip_relocation, monterey:       "097a752102d1126b9c5a4efbe290770414fea245463fef2b7d5e56988456d8d4"
    sha256 cellar: :any_skip_relocation, big_sur:        "097a752102d1126b9c5a4efbe290770414fea245463fef2b7d5e56988456d8d4"
    sha256 cellar: :any_skip_relocation, catalina:       "097a752102d1126b9c5a4efbe290770414fea245463fef2b7d5e56988456d8d4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "079f749387e1b4e48a548f89be058aeb148633e8dfa4b52033a2240c63109920"
  end

  depends_on "node"
  depends_on "postgresql"

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
