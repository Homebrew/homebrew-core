class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.14.0.tgz"
  sha256 "7d7206f0a3c197358e616c02ca13de1b6889552a049ccf047c8a89e66117be81"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    rebuild 1
    sha256 cellar: :any_skip_relocation, arm64_sequoia:  "e0c2fcfe4e73f4224b5b6a8605933278dda3c3be9e58c4547cbb0726e095133c"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "0d559cbf994b6369a77a7df1876d347add8774960443be089a655f28862f1400"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0d559cbf994b6369a77a7df1876d347add8774960443be089a655f28862f1400"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d559cbf994b6369a77a7df1876d347add8774960443be089a655f28862f1400"
    sha256 cellar: :any_skip_relocation, sonoma:         "1f781319e03509553933493a7c96234f84ac88b9c0afde001b70e13b768bec23"
    sha256 cellar: :any_skip_relocation, ventura:        "1f781319e03509553933493a7c96234f84ac88b9c0afde001b70e13b768bec23"
    sha256 cellar: :any_skip_relocation, monterey:       "1f781319e03509553933493a7c96234f84ac88b9c0afde001b70e13b768bec23"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "680fa557c1ebef6293aa26a8b2003bba8b009e5e82d99d0bb4805b57e6e921bd"
  end

  depends_on "postgresql@16" => :test
  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    ENV["LC_ALL"] = "C"
    assert_match "postgraphile", shell_output("#{bin}/postgraphile --help")

    pg_bin = Formula["postgresql@16"].opt_bin
    system "#{pg_bin}/initdb", "-D", testpath/"test"
    pid = fork do
      exec("#{pg_bin}/postgres", "-D", testpath/"test")
    end

    begin
      sleep 2
      system "#{pg_bin}/createdb", "test"
      system bin/"postgraphile", "-c", "postgres:///test", "-X"
    ensure
      Process.kill 9, pid
      Process.wait pid
    end
  end
end
