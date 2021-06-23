require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.40.tgz"
  sha256 "c88af00eb4b1a0fe9ae23859e53d50e7d3107f3c2e4f1930d2971b52ceb4c574"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "908467bfa451939838213294f2ab175a68c3bda5fb6218a6894f85da8c828262"
    sha256 cellar: :any_skip_relocation, big_sur:       "36fcaa712c221872cb27b8bbaa986c1b73081cb54eb2846beafe23f43f7f870a"
    sha256 cellar: :any_skip_relocation, catalina:      "36fcaa712c221872cb27b8bbaa986c1b73081cb54eb2846beafe23f43f7f870a"
    sha256 cellar: :any_skip_relocation, mojave:        "36fcaa712c221872cb27b8bbaa986c1b73081cb54eb2846beafe23f43f7f870a"
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
