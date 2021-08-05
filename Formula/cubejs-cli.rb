require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.14.tgz"
  sha256 "0c5b9ac9a06617bee74c86eac97dce71ba7b488b070eb6cadae9fd3e5345a59b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f2f8d3cd9c443d83a2dc86c069c2084ffd14a11b6bed40a0d8597d343a01b0c4"
    sha256 cellar: :any_skip_relocation, big_sur:       "5c131abee692f3041a38559c98fabe8bab38efce21d95986143297fc1f216d17"
    sha256 cellar: :any_skip_relocation, catalina:      "5c131abee692f3041a38559c98fabe8bab38efce21d95986143297fc1f216d17"
    sha256 cellar: :any_skip_relocation, mojave:        "5c131abee692f3041a38559c98fabe8bab38efce21d95986143297fc1f216d17"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f2f8d3cd9c443d83a2dc86c069c2084ffd14a11b6bed40a0d8597d343a01b0c4"
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
