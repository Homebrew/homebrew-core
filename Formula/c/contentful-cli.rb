require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.45.tgz"
  sha256 "4e8475cf72e0972db3e3a3bc951a9401d8fddf66bf1ec0106ca779756f6c46e3"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3059ba15298baabaadcc6ee574ab7cd7da50bed88e93295580d36d1e946a8d0c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3059ba15298baabaadcc6ee574ab7cd7da50bed88e93295580d36d1e946a8d0c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3059ba15298baabaadcc6ee574ab7cd7da50bed88e93295580d36d1e946a8d0c"
    sha256 cellar: :any_skip_relocation, ventura:        "5574db92ebad709eed75f2a5dc74874447bc050e560545d70d80b730c495a37e"
    sha256 cellar: :any_skip_relocation, monterey:       "5574db92ebad709eed75f2a5dc74874447bc050e560545d70d80b730c495a37e"
    sha256 cellar: :any_skip_relocation, big_sur:        "5574db92ebad709eed75f2a5dc74874447bc050e560545d70d80b730c495a37e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3059ba15298baabaadcc6ee574ab7cd7da50bed88e93295580d36d1e946a8d0c"
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
