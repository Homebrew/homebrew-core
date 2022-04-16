require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.12.15.tgz"
  sha256 "7880ee49a2a184a971272fbd322c98e83c4ae21e18f147aaeb6beea393c032a0"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4dd4e99d1da36eafc0edbbf390ca0df840529eb8a48b330b2a087a4e771d964d"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4dd4e99d1da36eafc0edbbf390ca0df840529eb8a48b330b2a087a4e771d964d"
    sha256 cellar: :any_skip_relocation, monterey:       "d670ad56cb86a8e6ed971c4b73cb6ce3b89e1c6c15de1fc2cdeb27f6c9ed4377"
    sha256 cellar: :any_skip_relocation, big_sur:        "d670ad56cb86a8e6ed971c4b73cb6ce3b89e1c6c15de1fc2cdeb27f6c9ed4377"
    sha256 cellar: :any_skip_relocation, catalina:       "d670ad56cb86a8e6ed971c4b73cb6ce3b89e1c6c15de1fc2cdeb27f6c9ed4377"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4dd4e99d1da36eafc0edbbf390ca0df840529eb8a48b330b2a087a4e771d964d"
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
