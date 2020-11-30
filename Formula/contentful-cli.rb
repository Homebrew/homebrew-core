require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.4.61.tgz"
  sha256 "38df36a3093c70eb393696c29bd60c03c4c4cae7df3a23e19be1738323111534"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "6c429fc65b3e5f3586c8a053e880def20f6210722fc1cfe2ee527829a0124d06" => :big_sur
    sha256 "4d8c05198409429a2a4388a8d97652b08dd79bdba5856e33981515310aa34086" => :catalina
    sha256 "a0c1c82c8cb4e47cb6a66933db0f465e89d881e50df69e7e94fe434456c3e9bb" => :mojave
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
