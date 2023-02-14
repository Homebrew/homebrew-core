require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.62.tgz"
  sha256 "b28c87fb32aa90e5904758dad7c1cd4e138fbe5e551578f02a76b9421fac2907"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "0477827db9eb3f10546839253796a22f3f63d1d3d8a581282ba2c178869428c4"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0477827db9eb3f10546839253796a22f3f63d1d3d8a581282ba2c178869428c4"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0477827db9eb3f10546839253796a22f3f63d1d3d8a581282ba2c178869428c4"
    sha256 cellar: :any_skip_relocation, ventura:        "8a9be3ee278a6d2e5c6633b79829fd63c0a94824d6e03c94e1541e402935ea6b"
    sha256 cellar: :any_skip_relocation, monterey:       "8a9be3ee278a6d2e5c6633b79829fd63c0a94824d6e03c94e1541e402935ea6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "8a9be3ee278a6d2e5c6633b79829fd63c0a94824d6e03c94e1541e402935ea6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0477827db9eb3f10546839253796a22f3f63d1d3d8a581282ba2c178869428c4"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/cubejs --version")
    system bin/"cubejs", "create", "hello-world", "-d", "postgres"
    assert_predicate testpath/"hello-world/schema/Orders.js", :exist?
  end
end
