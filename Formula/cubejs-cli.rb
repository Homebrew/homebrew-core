require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.42.tgz"
  sha256 "6973bf3703af16844f4d9bc872980034d903ef45d7aeab107badcfb97d92cfc4"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "14c4297316a43c423fe1cc22f3b1016bd312940f0fd584b2fbb874a78849f1a3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "14c4297316a43c423fe1cc22f3b1016bd312940f0fd584b2fbb874a78849f1a3"
    sha256 cellar: :any_skip_relocation, monterey:       "459a4754562f4d2713fc322de3dfd29b7f3c5e987ce57903f07ed32937496970"
    sha256 cellar: :any_skip_relocation, big_sur:        "459a4754562f4d2713fc322de3dfd29b7f3c5e987ce57903f07ed32937496970"
    sha256 cellar: :any_skip_relocation, catalina:       "459a4754562f4d2713fc322de3dfd29b7f3c5e987ce57903f07ed32937496970"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "14c4297316a43c423fe1cc22f3b1016bd312940f0fd584b2fbb874a78849f1a3"
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
