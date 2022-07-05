require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.30.30.tgz"
  sha256 "2965db716a7dbd589f5d7188c691f0c3956e14efe0916504d6bd73f58bad541b"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "7fa4190f15a2dc9d3d4a046c451ab7968928de7f1a9ff2f5e34dfec93d1ed045"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7fa4190f15a2dc9d3d4a046c451ab7968928de7f1a9ff2f5e34dfec93d1ed045"
    sha256 cellar: :any_skip_relocation, monterey:       "0dea91d8054b16620352a3803de86da45a72c0ef5b81c6daebe6bd072db36f22"
    sha256 cellar: :any_skip_relocation, big_sur:        "0dea91d8054b16620352a3803de86da45a72c0ef5b81c6daebe6bd072db36f22"
    sha256 cellar: :any_skip_relocation, catalina:       "0dea91d8054b16620352a3803de86da45a72c0ef5b81c6daebe6bd072db36f22"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fa4190f15a2dc9d3d4a046c451ab7968928de7f1a9ff2f5e34dfec93d1ed045"
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
