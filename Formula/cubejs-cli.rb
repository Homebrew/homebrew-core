require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.16.tgz"
  sha256 "a9032c4205c54fb8323af8d89a0a9d057adfe782bf420bde78ede7395a04d0fa"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "47197408160fc09e675c0f001baa3062ceb4093656c67b6beecc50e398100720"
    sha256 cellar: :any_skip_relocation, big_sur:       "d836210d196e50050dda475b6965eaad10426772e8335503d47c3ce2f127f443"
    sha256 cellar: :any_skip_relocation, catalina:      "ca236ebc3ac0d1f8e4f1ba2df82a90369a1dd6f9f4ff991c56d76643e6a3b9ed"
    sha256 cellar: :any_skip_relocation, mojave:        "092890bd3b612b81e9cc2ef7b0d2943129768a070272678a4b1da1d9cd3fa514"
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
