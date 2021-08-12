require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.15.tgz"
  sha256 "278e8121dd79a3de13748d6b57224b90674c4e633cb38abde590d8d6a0549750"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "807421ef49b01baad4ab0493218bfcfe9d472cc851f7ca63c9d22a1cc75f25eb"
    sha256 cellar: :any_skip_relocation, big_sur:       "4eee4ef1a33fcb1cdf186fa054aebecab0178f1bae00437c58371d21d3f703f1"
    sha256 cellar: :any_skip_relocation, catalina:      "4eee4ef1a33fcb1cdf186fa054aebecab0178f1bae00437c58371d21d3f703f1"
    sha256 cellar: :any_skip_relocation, mojave:        "4eee4ef1a33fcb1cdf186fa054aebecab0178f1bae00437c58371d21d3f703f1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "807421ef49b01baad4ab0493218bfcfe9d472cc851f7ca63c9d22a1cc75f25eb"
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
