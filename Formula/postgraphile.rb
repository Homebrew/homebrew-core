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
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e6b0955cb25afd5de00af7cdf76795cc05e59c6e5400a4d77549d34dd491fe37"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e6b0955cb25afd5de00af7cdf76795cc05e59c6e5400a4d77549d34dd491fe37"
    sha256 cellar: :any_skip_relocation, monterey:       "691b74c540b3b2011c1717f84a1b3c15b7a875365b37e42fb71b7821e228fc89"
    sha256 cellar: :any_skip_relocation, big_sur:        "691b74c540b3b2011c1717f84a1b3c15b7a875365b37e42fb71b7821e228fc89"
    sha256 cellar: :any_skip_relocation, catalina:       "691b74c540b3b2011c1717f84a1b3c15b7a875365b37e42fb71b7821e228fc89"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e6b0955cb25afd5de00af7cdf76795cc05e59c6e5400a4d77549d34dd491fe37"
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
