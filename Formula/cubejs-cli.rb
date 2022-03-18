require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.33.tgz"
  sha256 "85827b33e00df88ad06ef85f69c9b84a678f0dea93b77825cec45b4667999355"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b0a4a15dae8ecf1736a9c20e5e7380278e29a62d2719f42373270715a8b50695"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b0a4a15dae8ecf1736a9c20e5e7380278e29a62d2719f42373270715a8b50695"
    sha256 cellar: :any_skip_relocation, monterey:       "9e9d4f0f85ce65e8b504fb9cde69648f036f8e9dc5bc812dca5341a537fc0094"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e9d4f0f85ce65e8b504fb9cde69648f036f8e9dc5bc812dca5341a537fc0094"
    sha256 cellar: :any_skip_relocation, catalina:       "9e9d4f0f85ce65e8b504fb9cde69648f036f8e9dc5bc812dca5341a537fc0094"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b0a4a15dae8ecf1736a9c20e5e7380278e29a62d2719f42373270715a8b50695"
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
