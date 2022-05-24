require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.35.tgz"
  sha256 "d02a056f095676265961f0ccebf174b2d982a5125d43986cae9778ed48d78803"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "81b5384dd40790de911e0493eac82c70c98cb97a62068f3bec113262c0673656"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "81b5384dd40790de911e0493eac82c70c98cb97a62068f3bec113262c0673656"
    sha256 cellar: :any_skip_relocation, monterey:       "f1f513a94a25f839272dceb61b0f0cabbdd06e573469fa723957c906a349212f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f1f513a94a25f839272dceb61b0f0cabbdd06e573469fa723957c906a349212f"
    sha256 cellar: :any_skip_relocation, catalina:       "f1f513a94a25f839272dceb61b0f0cabbdd06e573469fa723957c906a349212f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "81b5384dd40790de911e0493eac82c70c98cb97a62068f3bec113262c0673656"
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
