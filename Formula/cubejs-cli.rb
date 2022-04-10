require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.45.tgz"
  sha256 "79911f3ca1499f47b9f938af0a06ad9f497e50b63dc8e69f16b2f0b2609ff42d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2f2d0d07742006d21bf7c58ec1fe67718422e5f538081a6fb428dbc8fc1aaefa"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2f2d0d07742006d21bf7c58ec1fe67718422e5f538081a6fb428dbc8fc1aaefa"
    sha256 cellar: :any_skip_relocation, monterey:       "26fccdb2e125dbf5e67cc8335866547cd07469f55a8f7eb4575438cfc0ad0d7a"
    sha256 cellar: :any_skip_relocation, big_sur:        "26fccdb2e125dbf5e67cc8335866547cd07469f55a8f7eb4575438cfc0ad0d7a"
    sha256 cellar: :any_skip_relocation, catalina:       "26fccdb2e125dbf5e67cc8335866547cd07469f55a8f7eb4575438cfc0ad0d7a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2f2d0d07742006d21bf7c58ec1fe67718422e5f538081a6fb428dbc8fc1aaefa"
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
