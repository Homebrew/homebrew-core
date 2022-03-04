require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.29.29.tgz"
  sha256 "d3e6ddee1ad7a620c7d96dd46fa8cefbc213980b1ae9fa34a9585c81cc28d8f1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "84e4500d837ae24b609a6bd64ea7925850b0c3c82cf8ad9c4fe9c1efd3f9ee64"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "84e4500d837ae24b609a6bd64ea7925850b0c3c82cf8ad9c4fe9c1efd3f9ee64"
    sha256 cellar: :any_skip_relocation, monterey:       "0f354b2e080d291d87d9ab33178960c6c11e7b8362a7ca8d730e14c71f55bdc6"
    sha256 cellar: :any_skip_relocation, big_sur:        "0f354b2e080d291d87d9ab33178960c6c11e7b8362a7ca8d730e14c71f55bdc6"
    sha256 cellar: :any_skip_relocation, catalina:       "0f354b2e080d291d87d9ab33178960c6c11e7b8362a7ca8d730e14c71f55bdc6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "84e4500d837ae24b609a6bd64ea7925850b0c3c82cf8ad9c4fe9c1efd3f9ee64"
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
