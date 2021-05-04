require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.15.tgz"
  sha256 "2ee2da70e12c4502b29f35ec928e20555be3c29f8d62e7614def22bfe01789cd"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6f9424f135dfcbb7654df54ccb6abba8649e903400df13a9f9021224f6924970"
    sha256 cellar: :any_skip_relocation, big_sur:       "6e871ff6e201a37958ba3631c43d974f52138265367ca8942e9d7de7e1d1a7eb"
    sha256 cellar: :any_skip_relocation, catalina:      "307b85d913909606b9eb4fab412861e0d0c26c5c98eb1d14e6bea5c0d685a68f"
    sha256 cellar: :any_skip_relocation, mojave:        "a49ba47426feec5f7892c2290a7b7c0dd7b13b6a902e1f24ca3b790abe703443"
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
