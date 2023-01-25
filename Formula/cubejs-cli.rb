require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.53.tgz"
  sha256 "3d78453591c20a498154b20d92418ff7eae2b54cef2fc65eedbdf6babd725a56"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c4883647192b1e6a8867bad4a4a471026064d0ca17f074474d60213460610615"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c4883647192b1e6a8867bad4a4a471026064d0ca17f074474d60213460610615"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c4883647192b1e6a8867bad4a4a471026064d0ca17f074474d60213460610615"
    sha256 cellar: :any_skip_relocation, ventura:        "d6c1183d42f1f49ed818a2c8ad855b5679670a344e8eb6bf63ae8159656ab5f0"
    sha256 cellar: :any_skip_relocation, monterey:       "d6c1183d42f1f49ed818a2c8ad855b5679670a344e8eb6bf63ae8159656ab5f0"
    sha256 cellar: :any_skip_relocation, big_sur:        "d6c1183d42f1f49ed818a2c8ad855b5679670a344e8eb6bf63ae8159656ab5f0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c4883647192b1e6a8867bad4a4a471026064d0ca17f074474d60213460610615"
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
