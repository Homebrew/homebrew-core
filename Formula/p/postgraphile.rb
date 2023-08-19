require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.13.0.tgz"
  sha256 "bdf6c3047b16fd7bddc2eabd74939b986bc2fa0f56383f409fa3d7d95418cf77"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "89fe3ed5c28e49b954f36201b2c1b641a38ec737216ff48ca04aa63256156334"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "89fe3ed5c28e49b954f36201b2c1b641a38ec737216ff48ca04aa63256156334"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "89fe3ed5c28e49b954f36201b2c1b641a38ec737216ff48ca04aa63256156334"
    sha256 cellar: :any_skip_relocation, ventura:        "f4eba09e6051328f2d1ece4bb1c5539cb78112912afe17034a72d922e07f0814"
    sha256 cellar: :any_skip_relocation, monterey:       "f4eba09e6051328f2d1ece4bb1c5539cb78112912afe17034a72d922e07f0814"
    sha256 cellar: :any_skip_relocation, big_sur:        "f4eba09e6051328f2d1ece4bb1c5539cb78112912afe17034a72d922e07f0814"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "89fe3ed5c28e49b954f36201b2c1b641a38ec737216ff48ca04aa63256156334"
  end

  depends_on "postgresql@14" => :test
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql@14"].opt_bin
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
