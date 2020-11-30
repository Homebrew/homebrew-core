require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.62.tgz"
  sha256 "b86c4a10efd3b02b588925b9c3c598334debd62487e78ef852b7c766c5bc74c5"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "7b4bbc7234653f1768cef329840695906ea3fa414e74da77151f21954a970a27" => :big_sur
    sha256 "4a306e23b27733d92b98b12261f44a7b391dbca5f3b5bedfb286f42c050d3e6f" => :catalina
    sha256 "d40c58894dedac41d51050242600e3f2846bfb40ad81da9a35a23eca35eda257" => :mojave
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
