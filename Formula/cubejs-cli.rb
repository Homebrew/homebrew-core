require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.45.tgz"
  sha256 "35b1890b14c7d966fb01b5b0283f1e090b114eeeceb85ba8345eb91872cb6cd7"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5159f0a21fbca1aa9cfba1cd6f4c1311e9e50ecd3cee422ae0bdd8ebd9c2115"
    sha256 cellar: :any_skip_relocation, big_sur:       "4b0b5a37ea770fb67d2fc8513a3f8359b4949986f0c494327b158811bf69bda1"
    sha256 cellar: :any_skip_relocation, catalina:      "99fd073afa6dc728863ebd76faac23ffc140551bb6d5d7aadb9786fc4f418767"
    sha256 cellar: :any_skip_relocation, mojave:        "4b0b5a37ea770fb67d2fc8513a3f8359b4949986f0c494327b158811bf69bda1"
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
