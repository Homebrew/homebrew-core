require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.28.13.tgz"
  sha256 "ad7d926d0359a82605312b779eaedc66a53a7416c6aed14764ca682cb347eef1"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1ba896f39347e44ce23fdc6853e3d712b446b889edac6fc790f33bd9c4f51a8d"
    sha256 cellar: :any_skip_relocation, big_sur:       "6fc798f998053128e292e726fe31a77e86d3300a1d9e7df1598a928add0df106"
    sha256 cellar: :any_skip_relocation, catalina:      "6fc798f998053128e292e726fe31a77e86d3300a1d9e7df1598a928add0df106"
    sha256 cellar: :any_skip_relocation, mojave:        "6fc798f998053128e292e726fe31a77e86d3300a1d9e7df1598a928add0df106"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1ba896f39347e44ce23fdc6853e3d712b446b889edac6fc790f33bd9c4f51a8d"
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
