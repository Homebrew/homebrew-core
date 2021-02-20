require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.16.tgz"
  sha256 "a9032c4205c54fb8323af8d89a0a9d057adfe782bf420bde78ede7395a04d0fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "17243af41d29b798a363e26ecec8407174300c8f17b7d017490f1e05f0b80cc6"
    sha256 cellar: :any_skip_relocation, big_sur:       "e65180d87efe8d531a1be80a1bd5065f4fe0225ca6da71c14bbc524c1fe04b0a"
    sha256 cellar: :any_skip_relocation, catalina:      "ce775aabbd6b13d9951c41d13e466cd9766dfb4cca44395bac616249beaddafb"
    sha256 cellar: :any_skip_relocation, mojave:        "d27066af205c9f0c5a79f626484d6b77fc7e4c1fa66da6acf485f89c1a48df7b"
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
