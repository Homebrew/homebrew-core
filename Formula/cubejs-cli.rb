require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.3.tgz"
  sha256 "e9177a5ffce1bd688cf68d5098cb0c09283983c7ba54e5cfebc5802c660b763d"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "45d076fe1fb12c666aaf14dc123638ba7044baa6f825ed21cab4ae65c38a695b"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "45d076fe1fb12c666aaf14dc123638ba7044baa6f825ed21cab4ae65c38a695b"
    sha256 cellar: :any_skip_relocation, monterey:       "bdfd87542693357bb5ad40394b0cc90af54aa977ce14b66431613ffef661eb39"
    sha256 cellar: :any_skip_relocation, big_sur:        "bdfd87542693357bb5ad40394b0cc90af54aa977ce14b66431613ffef661eb39"
    sha256 cellar: :any_skip_relocation, catalina:       "bdfd87542693357bb5ad40394b0cc90af54aa977ce14b66431613ffef661eb39"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "45d076fe1fb12c666aaf14dc123638ba7044baa6f825ed21cab4ae65c38a695b"
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
