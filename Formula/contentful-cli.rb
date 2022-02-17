require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.11.0.tgz"
  sha256 "4e09f0a625853f437f51a30436cd9a68080ca715558cc2686dee0736bc1e5aff"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8870b00018a7e1e92c65e993c4ddc7df9beafe6e75e7ba980bb0f7c2981815df"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8870b00018a7e1e92c65e993c4ddc7df9beafe6e75e7ba980bb0f7c2981815df"
    sha256 cellar: :any_skip_relocation, monterey:       "2dc62c43164c9afb633903ff61e0762e854f4e6a0c8e0e90afa1cd84c56fc721"
    sha256 cellar: :any_skip_relocation, big_sur:        "2dc62c43164c9afb633903ff61e0762e854f4e6a0c8e0e90afa1cd84c56fc721"
    sha256 cellar: :any_skip_relocation, catalina:       "2dc62c43164c9afb633903ff61e0762e854f4e6a0c8e0e90afa1cd84c56fc721"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8870b00018a7e1e92c65e993c4ddc7df9beafe6e75e7ba980bb0f7c2981815df"
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
