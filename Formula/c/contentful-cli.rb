require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-2.6.43.tgz"
  sha256 "26868ad633f2583d122e0ad3d98e2a4959ac313ce40d32ab527f3cdffdf973a6"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9aded96b9b677bae36b72b07d50b44ef7addd44100f7aff95934725c49eb1f26"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9aded96b9b677bae36b72b07d50b44ef7addd44100f7aff95934725c49eb1f26"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9aded96b9b677bae36b72b07d50b44ef7addd44100f7aff95934725c49eb1f26"
    sha256 cellar: :any_skip_relocation, ventura:        "65868daa162d1339e6ff6d712d1681becf2a068194231bf617327daa34eb7c99"
    sha256 cellar: :any_skip_relocation, monterey:       "65868daa162d1339e6ff6d712d1681becf2a068194231bf617327daa34eb7c99"
    sha256 cellar: :any_skip_relocation, big_sur:        "65868daa162d1339e6ff6d712d1681becf2a068194231bf617327daa34eb7c99"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9aded96b9b677bae36b72b07d50b44ef7addd44100f7aff95934725c49eb1f26"
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
