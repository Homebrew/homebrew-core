require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.35.tgz"
  sha256 "139e475809e39320a369d6b98901ae6e06202bacd481a3f5d6ae704e69500df3"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "7af1c3452f1347034c799930e641f03c35a12c2e55ef95b98661655706ff10cd"
    sha256 cellar: :any_skip_relocation, big_sur:       "f9b7173f45ec8b5de816e006d16bb211832dbb39ef9db00294f1414617560e57"
    sha256 cellar: :any_skip_relocation, catalina:      "f9b7173f45ec8b5de816e006d16bb211832dbb39ef9db00294f1414617560e57"
    sha256 cellar: :any_skip_relocation, mojave:        "f9b7173f45ec8b5de816e006d16bb211832dbb39ef9db00294f1414617560e57"
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
