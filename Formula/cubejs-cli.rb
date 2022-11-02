require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.10.tgz"
  sha256 "1d8ea21178308e039631070735a9a739d612399ce4df80e124c1baf387f02fff"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e764c77ef97354f36e696a0a747ce2741c899c28361ee891917ba4206fa0ff2a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e764c77ef97354f36e696a0a747ce2741c899c28361ee891917ba4206fa0ff2a"
    sha256 cellar: :any_skip_relocation, monterey:       "4dcd3da93713a3c32c234a3f2ce37091c3a71acc83743ca14c4c1ae6b0aa9a72"
    sha256 cellar: :any_skip_relocation, big_sur:        "4dcd3da93713a3c32c234a3f2ce37091c3a71acc83743ca14c4c1ae6b0aa9a72"
    sha256 cellar: :any_skip_relocation, catalina:       "4dcd3da93713a3c32c234a3f2ce37091c3a71acc83743ca14c4c1ae6b0aa9a72"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e764c77ef97354f36e696a0a747ce2741c899c28361ee891917ba4206fa0ff2a"
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
