require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema 🐘"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.12.10.tgz"
  sha256 "83c7045124f3d0f60f6adba0b8d6c174af2a50b05b619387c4012931120d3283"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e4077e72a27adf3f1119ca5327cfd2050a5f42d5637bb2863fca73eb3fa9350a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e4077e72a27adf3f1119ca5327cfd2050a5f42d5637bb2863fca73eb3fa9350a"
    sha256 cellar: :any_skip_relocation, monterey:       "6951deaa5bdac3191c2e57314dac3a71c94ba71823ef040298e56ecb2d2122cf"
    sha256 cellar: :any_skip_relocation, big_sur:        "6951deaa5bdac3191c2e57314dac3a71c94ba71823ef040298e56ecb2d2122cf"
    sha256 cellar: :any_skip_relocation, catalina:       "6951deaa5bdac3191c2e57314dac3a71c94ba71823ef040298e56ecb2d2122cf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e4077e72a27adf3f1119ca5327cfd2050a5f42d5637bb2863fca73eb3fa9350a"
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
