require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.34.tgz"
  sha256 "a72063762fe75727663af02ea38e14882c66509b13f5dce4e7c3297253144a35"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "916d81b54edbb99ce5e61ba78f265029cb15f018c8a5162267cde5d1639ea5bc"
    sha256 cellar: :any_skip_relocation, big_sur:       "628b82acf8a2699d2c73c6a33068e03f0ce78161d01d64b908347c6e5762046f"
    sha256 cellar: :any_skip_relocation, catalina:      "628b82acf8a2699d2c73c6a33068e03f0ce78161d01d64b908347c6e5762046f"
    sha256 cellar: :any_skip_relocation, mojave:        "628b82acf8a2699d2c73c6a33068e03f0ce78161d01d64b908347c6e5762046f"
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
