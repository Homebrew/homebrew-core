require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.41.tgz"
  sha256 "a778181c364fd1b91eb3356ccd7ebe5c08d925b742a132f15a37218b2b459f0d"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "706213164b370472e230ac1258817766e242b23a5735520d0c46dca120565e47"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "706213164b370472e230ac1258817766e242b23a5735520d0c46dca120565e47"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "706213164b370472e230ac1258817766e242b23a5735520d0c46dca120565e47"
    sha256 cellar: :any_skip_relocation, ventura:        "5a22368170e1fdad496ed3b602461670d14e731b28934b564ac3d5991b370629"
    sha256 cellar: :any_skip_relocation, monterey:       "5a22368170e1fdad496ed3b602461670d14e731b28934b564ac3d5991b370629"
    sha256 cellar: :any_skip_relocation, big_sur:        "5a22368170e1fdad496ed3b602461670d14e731b28934b564ac3d5991b370629"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "706213164b370472e230ac1258817766e242b23a5735520d0c46dca120565e47"
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
