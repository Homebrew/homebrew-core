require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.13.tgz"
  sha256 "d7141939e497254c0d3cca1c60196c49b21f5e608000fd872fe70b9a4d31e9e4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "59c82964f93f19d9bae4c4fe00d4166d19e82a25f7bb94098aaf5a2a171f79d9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "59c82964f93f19d9bae4c4fe00d4166d19e82a25f7bb94098aaf5a2a171f79d9"
    sha256 cellar: :any_skip_relocation, monterey:       "f2e3274fae2ed9741273bb8ae7f1efda041d0cd7abe6317aeceaa6e05ed94b16"
    sha256 cellar: :any_skip_relocation, big_sur:        "f2e3274fae2ed9741273bb8ae7f1efda041d0cd7abe6317aeceaa6e05ed94b16"
    sha256 cellar: :any_skip_relocation, catalina:       "f2e3274fae2ed9741273bb8ae7f1efda041d0cd7abe6317aeceaa6e05ed94b16"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "59c82964f93f19d9bae4c4fe00d4166d19e82a25f7bb94098aaf5a2a171f79d9"
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
