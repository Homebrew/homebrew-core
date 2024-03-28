require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.44.tgz"
  sha256 "7acafe992dee313fda1b10c29c5bb4b94c8390b6326894a7d5b02c186f5a7d94"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "8db190a10554848a95208729a67317237c22daeb908ff86f9356c98ac47d0c69"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8db190a10554848a95208729a67317237c22daeb908ff86f9356c98ac47d0c69"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8db190a10554848a95208729a67317237c22daeb908ff86f9356c98ac47d0c69"
    sha256 cellar: :any_skip_relocation, sonoma:         "f860e952840b304ff584f5ba8592c0db1430bdb4af3a21a9406f6e8a948ca5d6"
    sha256 cellar: :any_skip_relocation, ventura:        "f860e952840b304ff584f5ba8592c0db1430bdb4af3a21a9406f6e8a948ca5d6"
    sha256 cellar: :any_skip_relocation, monterey:       "f860e952840b304ff584f5ba8592c0db1430bdb4af3a21a9406f6e8a948ca5d6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8db190a10554848a95208729a67317237c22daeb908ff86f9356c98ac47d0c69"
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
