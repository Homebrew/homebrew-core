require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.43.tgz"
  sha256 "73422c319aa599f1bdf66fc6805f3ceb9004f6ee9982fcd52a309770d5cf0067"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "4fc888cd0967393d87d941086f49d92e0982e1e6ef64f15085e2ae7d858f7f79" => :catalina
    sha256 "1df9ccd2730d747bdbcb9a935386b69fc5d0978ceb83ed7fa159156e1ca859bd" => :mojave
    sha256 "c44b09e1f45edf9987c1d6571eb21b5e6d36a9f9973bba698f17033420c60b62" => :high_sierra
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
