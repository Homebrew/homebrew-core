require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.15.tgz"
  sha256 "bd5e88dfee3ee1dec8d60189ca2b68e9bca0fb658e3efc03f3fd7e9acaca96c4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "64397036f93a2df3a99c5f98bc212d2b3cf4dfe01f6dd0e55ee379afaed5639d"
    sha256 cellar: :any_skip_relocation, big_sur:       "a90f83eafda0335ee2ee5251d8007bbb52343b786a58a87027813906ceba8b55"
    sha256 cellar: :any_skip_relocation, catalina:      "a90f83eafda0335ee2ee5251d8007bbb52343b786a58a87027813906ceba8b55"
    sha256 cellar: :any_skip_relocation, mojave:        "a90f83eafda0335ee2ee5251d8007bbb52343b786a58a87027813906ceba8b55"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system "cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
