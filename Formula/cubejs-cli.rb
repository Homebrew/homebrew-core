require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.26.11.tgz"
  sha256 "24277f53af196205c527be49fa2c969c4108495d2a63d4b3ae9e528b789cead7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4203546459760cc278a8f216a8ddfca7c7839cc65b2568ccc118d8b74dc4e74a"
    sha256 cellar: :any_skip_relocation, big_sur:       "044d04fc693f451979c14586bbe5416516ca6e4cd786e65157f3f4da374a4aa3"
    sha256 cellar: :any_skip_relocation, catalina:      "7509ed183b9d18cb78bb811078a410a1f7b63c5beeed32023957782b9f8f1872"
    sha256 cellar: :any_skip_relocation, mojave:        "f12fff5d58c7c4c0872b4c1daa3d5469d0756ada07f7405bf6391068e6ed6c99"
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
