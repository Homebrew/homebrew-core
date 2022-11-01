require "language/node"

class CubejsCli < Formula
  desc "Cube.js command-line interface"
  homepage "https://cube.dev/"
  url "https://registry.npmjs.org/cubejs-cli/-/cubejs-cli-0.31.9.tgz"
  sha256 "dcb3566372a2580c8609a41e17253a39c68173ab309dbe5e620210f357c9401f"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b83f171026904f14320ae2e855b1906b9ab7e869e254254d1615dffdd1564b16"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b83f171026904f14320ae2e855b1906b9ab7e869e254254d1615dffdd1564b16"
    sha256 cellar: :any_skip_relocation, monterey:       "30362f80e6b2668b73b9dffd2b08ba4af5680a8fe8e615272b087c0e7bb3e8dd"
    sha256 cellar: :any_skip_relocation, big_sur:        "30362f80e6b2668b73b9dffd2b08ba4af5680a8fe8e615272b087c0e7bb3e8dd"
    sha256 cellar: :any_skip_relocation, catalina:       "30362f80e6b2668b73b9dffd2b08ba4af5680a8fe8e615272b087c0e7bb3e8dd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b83f171026904f14320ae2e855b1906b9ab7e869e254254d1615dffdd1564b16"
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
