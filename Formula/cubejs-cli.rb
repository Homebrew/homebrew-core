require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.51.tgz"
  sha256 "b148b8c74a69c26fe4fc543bc76172b622c5fb46ef13dbd17ead0c612f9dcc1b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "6d1c2b2fbf6e2319a09bba240494969821909a4b2a3d97c16969a146937d8251"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6d1c2b2fbf6e2319a09bba240494969821909a4b2a3d97c16969a146937d8251"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6d1c2b2fbf6e2319a09bba240494969821909a4b2a3d97c16969a146937d8251"
    sha256 cellar: :any_skip_relocation, ventura:        "f6f08c9c710f89ab30dd915fefccb27c7e9fb6f561cdf3b500de88a2462f584f"
    sha256 cellar: :any_skip_relocation, monterey:       "f6f08c9c710f89ab30dd915fefccb27c7e9fb6f561cdf3b500de88a2462f584f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f6f08c9c710f89ab30dd915fefccb27c7e9fb6f561cdf3b500de88a2462f584f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "6d1c2b2fbf6e2319a09bba240494969821909a4b2a3d97c16969a146937d8251"
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
