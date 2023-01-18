require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.47.tgz"
  sha256 "a77fc26609197ab7d4b3b7ee152e1bdb7ab3b4efaf45abc185ef44156997cf51"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "b08e07ec166718363f893715d3a695825dded096f50978f912f401072cf5c179"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b08e07ec166718363f893715d3a695825dded096f50978f912f401072cf5c179"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b08e07ec166718363f893715d3a695825dded096f50978f912f401072cf5c179"
    sha256 cellar: :any_skip_relocation, ventura:        "92d0a83ad6df3c868d2863c31714e2e93f3bb28006b27454bc55b752c7f65974"
    sha256 cellar: :any_skip_relocation, monterey:       "92d0a83ad6df3c868d2863c31714e2e93f3bb28006b27454bc55b752c7f65974"
    sha256 cellar: :any_skip_relocation, big_sur:        "92d0a83ad6df3c868d2863c31714e2e93f3bb28006b27454bc55b752c7f65974"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b08e07ec166718363f893715d3a695825dded096f50978f912f401072cf5c179"
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
