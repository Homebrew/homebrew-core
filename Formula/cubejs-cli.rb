require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.27.14.tgz"
  sha256 "1da048b69a8274eda4b6e1e96638f2563146a0275127f6e8c9e4fa93904e4922"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "155dd0072f1670e8fca97270e8ac1dc49c09b6de1c0400acf672a2282a059205"
    sha256 cellar: :any_skip_relocation, big_sur:       "149b43f3fa7c84c35c65668e8531694bd2f60448e982446add0ddd6cffe9ae78"
    sha256 cellar: :any_skip_relocation, catalina:      "149b43f3fa7c84c35c65668e8531694bd2f60448e982446add0ddd6cffe9ae78"
    sha256 cellar: :any_skip_relocation, mojave:        "149b43f3fa7c84c35c65668e8531694bd2f60448e982446add0ddd6cffe9ae78"
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
