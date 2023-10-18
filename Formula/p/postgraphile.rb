require "language/node"

class Postgraphile < Formula
  desc "GraphQL schema created by reflection over a PostgreSQL schema"
  homepage "https://www.graphile.org/postgraphile/"
  url "https://registry.npmjs.org/postgraphile/-/postgraphile-4.14.0.tgz"
  sha256 "7d7206f0a3c197358e616c02ca13de1b6889552a049ccf047c8a89e66117be81"
  license "MIT"
  head "https://github.com/graphile/postgraphile.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "93aa60a1cb7e1f15b1efafc8e26b7e0474aaa6b30900bca94acd506df8ad5d1c"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "93aa60a1cb7e1f15b1efafc8e26b7e0474aaa6b30900bca94acd506df8ad5d1c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "93aa60a1cb7e1f15b1efafc8e26b7e0474aaa6b30900bca94acd506df8ad5d1c"
    sha256 cellar: :any_skip_relocation, sonoma:         "166a675cb3012afad87ba3e40697d8c938f2bbefaa428f8fe2236eb86777b1fd"
    sha256 cellar: :any_skip_relocation, ventura:        "166a675cb3012afad87ba3e40697d8c938f2bbefaa428f8fe2236eb86777b1fd"
    sha256 cellar: :any_skip_relocation, monterey:       "166a675cb3012afad87ba3e40697d8c938f2bbefaa428f8fe2236eb86777b1fd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "93aa60a1cb7e1f15b1efafc8e26b7e0474aaa6b30900bca94acd506df8ad5d1c"
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
