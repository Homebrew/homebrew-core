require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.27.tgz"
  sha256 "4b23e81a4b91591644688991dbb768f1fd35d762a518fc9f439a00fbe2fb3fb7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "603684b30637ad16a4e762674a9c013fb38f1803605ef3d958f7617e63ee6fa2"
    sha256 cellar: :any_skip_relocation, big_sur:       "0a54703d3d6140e14c665678a6d26ecfe8bad8853d27f89284cd956aa802c27c"
    sha256 cellar: :any_skip_relocation, catalina:      "0a54703d3d6140e14c665678a6d26ecfe8bad8853d27f89284cd956aa802c27c"
    sha256 cellar: :any_skip_relocation, mojave:        "0a54703d3d6140e14c665678a6d26ecfe8bad8853d27f89284cd956aa802c27c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "603684b30637ad16a4e762674a9c013fb38f1803605ef3d958f7617e63ee6fa2"
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
