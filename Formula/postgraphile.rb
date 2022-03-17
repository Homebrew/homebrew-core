require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema 🐘"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.12.9.tgz"
  sha256 "dd9a8446cc8e29640ce6ddc94cb7a9e812718755598053686f63fbe49a71c166"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e977c5c5939788b20805dad251ee30df6da83535c1b10ce2176055f87a071f76"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e977c5c5939788b20805dad251ee30df6da83535c1b10ce2176055f87a071f76"
    sha256 cellar: :any_skip_relocation, monterey:       "bbaa69dfb388ff4a7c9e95d20dc7b389eff49deabbd6b7e31217554f9184d4e7"
    sha256 cellar: :any_skip_relocation, big_sur:        "bbaa69dfb388ff4a7c9e95d20dc7b389eff49deabbd6b7e31217554f9184d4e7"
    sha256 cellar: :any_skip_relocation, catalina:       "bbaa69dfb388ff4a7c9e95d20dc7b389eff49deabbd6b7e31217554f9184d4e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e977c5c5939788b20805dad251ee30df6da83535c1b10ce2176055f87a071f76"
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
