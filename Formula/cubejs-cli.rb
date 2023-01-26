require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.54.tgz"
  sha256 "6f277a59ec1ccd50fbcb9d3b0e641c16cf4cd4090f2e1fb82cbf01d387d0dd6d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "66686027fd24e3c3b9eb52d1640115095d8b1c301df929edce947a09f26a948e"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "66686027fd24e3c3b9eb52d1640115095d8b1c301df929edce947a09f26a948e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "66686027fd24e3c3b9eb52d1640115095d8b1c301df929edce947a09f26a948e"
    sha256 cellar: :any_skip_relocation, ventura:        "6b38bfba33118b2050e4edc969fcebacfd99c01438b202035880190448153c93"
    sha256 cellar: :any_skip_relocation, monterey:       "6b38bfba33118b2050e4edc969fcebacfd99c01438b202035880190448153c93"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b38bfba33118b2050e4edc969fcebacfd99c01438b202035880190448153c93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "66686027fd24e3c3b9eb52d1640115095d8b1c301df929edce947a09f26a948e"
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
