require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.11.0.tgz"
  sha256 "4e09f0a625853f437f51a30436cd9a68080ca715558cc2686dee0736bc1e5aff"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "1ca2e29142cc3439ad52348a065b2063cb195c034c6c5682da126f7b47df21d1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "1ca2e29142cc3439ad52348a065b2063cb195c034c6c5682da126f7b47df21d1"
    sha256 cellar: :any_skip_relocation, monterey:       "5f5ffdecf721fc3024b584a9637a16917e04637a978e1e53d108ca9b17c8b9c9"
    sha256 cellar: :any_skip_relocation, big_sur:        "5f5ffdecf721fc3024b584a9637a16917e04637a978e1e53d108ca9b17c8b9c9"
    sha256 cellar: :any_skip_relocation, catalina:       "5f5ffdecf721fc3024b584a9637a16917e04637a978e1e53d108ca9b17c8b9c9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1ca2e29142cc3439ad52348a065b2063cb195c034c6c5682da126f7b47df21d1"
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
