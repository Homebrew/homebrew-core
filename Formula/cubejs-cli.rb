require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.32.1.tgz"
  sha256 "d200a7e5f1b7d7ff0406f012c0017ed9ac2f7de2859ed827ea67d002e9869a02"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6f28a2c5f07177e5f8406acae7aea7a54de8cf25f3c4cd2b8ea64b56696c8d2e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6f28a2c5f07177e5f8406acae7aea7a54de8cf25f3c4cd2b8ea64b56696c8d2e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6f28a2c5f07177e5f8406acae7aea7a54de8cf25f3c4cd2b8ea64b56696c8d2e"
    sha256 cellar: :any_skip_relocation, ventura:        "eb5eeb7ead4bc2debcebb4bb8865b0a338000fe41f903a4fc133df528ef2dcc5"
    sha256 cellar: :any_skip_relocation, monterey:       "eb5eeb7ead4bc2debcebb4bb8865b0a338000fe41f903a4fc133df528ef2dcc5"
    sha256 cellar: :any_skip_relocation, big_sur:        "eb5eeb7ead4bc2debcebb4bb8865b0a338000fe41f903a4fc133df528ef2dcc5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6f28a2c5f07177e5f8406acae7aea7a54de8cf25f3c4cd2b8ea64b56696c8d2e"
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
