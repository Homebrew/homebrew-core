require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.26.tgz"
  sha256 "1a624bcd3ecdc5743e3f0a2129bf59841fbbec68a4a91bf5b91d3bb7c0a0ab43"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "539ceacb8538b80be883e3fd63ea03e336190e51f49d606798d16c9252ef62f6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "539ceacb8538b80be883e3fd63ea03e336190e51f49d606798d16c9252ef62f6"
    sha256 cellar: :any_skip_relocation, monterey:       "b2412e31f97d2a1f44886e0907076e619233685461237ca9c3ec0cbf7a49a27f"
    sha256 cellar: :any_skip_relocation, big_sur:        "b2412e31f97d2a1f44886e0907076e619233685461237ca9c3ec0cbf7a49a27f"
    sha256 cellar: :any_skip_relocation, catalina:       "b2412e31f97d2a1f44886e0907076e619233685461237ca9c3ec0cbf7a49a27f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "539ceacb8538b80be883e3fd63ea03e336190e51f49d606798d16c9252ef62f6"
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
