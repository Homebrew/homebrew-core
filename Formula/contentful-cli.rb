require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.20.tgz"
  sha256 "857f353743e58db8d2e8168ee3b75ad005f737102cdbca41214d5efd95409290"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "10a22196223c3d9a204cb24818cc6ef0c71fd06d8bfa2e8662754489bfccce2b"
    sha256 cellar: :any_skip_relocation, big_sur:       "e5d86dae12dad761c948de60e2bfebadde625f9054dfbc206bb080faa428a4cd"
    sha256 cellar: :any_skip_relocation, catalina:      "e5d86dae12dad761c948de60e2bfebadde625f9054dfbc206bb080faa428a4cd"
    sha256 cellar: :any_skip_relocation, mojave:        "e5d86dae12dad761c948de60e2bfebadde625f9054dfbc206bb080faa428a4cd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "774d52cbafc55d030b7ef22b88b3efe3be8ad4721844265002b20c37ddd662bb"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/contentful space list 2>&1", 1)
    assert_match "🚨  Error: You have to be logged in to do this.", output
    assert_match "You can log in via contentful login", output
    assert_match "Or provide a management token via --management-token argument", output
  end
end
