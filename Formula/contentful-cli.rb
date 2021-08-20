require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.8.20.tgz"
  sha256 "857f353743e58db8d2e8168ee3b75ad005f737102cdbca41214d5efd95409290"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "4765a6bf58c944bbfccbd35f355654ec1b182fbb7963be60de145e4590f4881e"
    sha256 cellar: :any_skip_relocation, big_sur:       "20849d4f80fd6fc4b488707baa21f83530ca8157a3d00796e72d02effe0775e0"
    sha256 cellar: :any_skip_relocation, catalina:      "20849d4f80fd6fc4b488707baa21f83530ca8157a3d00796e72d02effe0775e0"
    sha256 cellar: :any_skip_relocation, mojave:        "20849d4f80fd6fc4b488707baa21f83530ca8157a3d00796e72d02effe0775e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "ec6fa72ddf52c370b4ba063e8ca50268362430d559b534ebf11a6ac188b67e65"
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
