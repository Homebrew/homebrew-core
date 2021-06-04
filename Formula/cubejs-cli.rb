require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.30.tgz"
  sha256 "bb4251e117fdc53eac712fe7244d9ab2d10b1e6350681941b548560f11a64a99"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "99d49240a5c5b512a03ab8305af523ed121402a82542682775db82e400102204"
    sha256 cellar: :any_skip_relocation, big_sur:       "447656dfb679873f9809c35cdce9b1b28dca636a12876b0dc5c67f2c37e47453"
    sha256 cellar: :any_skip_relocation, catalina:      "447656dfb679873f9809c35cdce9b1b28dca636a12876b0dc5c67f2c37e47453"
    sha256 cellar: :any_skip_relocation, mojave:        "447656dfb679873f9809c35cdce9b1b28dca636a12876b0dc5c67f2c37e47453"
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
