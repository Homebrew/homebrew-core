require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.37.tgz"
  sha256 "2e6a429dba45b5cf43360786f54c393ca84e97a11f01b55b152cd6f25df08e04"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "9a8824d7d9a316c2e5482c0db3e42aaafaabd6c53f11508126b9fc2cc9b80b35"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "9a8824d7d9a316c2e5482c0db3e42aaafaabd6c53f11508126b9fc2cc9b80b35"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9a8824d7d9a316c2e5482c0db3e42aaafaabd6c53f11508126b9fc2cc9b80b35"
    sha256 cellar: :any_skip_relocation, sonoma:         "f93cba7ab1a34fad7a7b147025958e827196b16a68925b62a1720c79a0f470ef"
    sha256 cellar: :any_skip_relocation, ventura:        "f93cba7ab1a34fad7a7b147025958e827196b16a68925b62a1720c79a0f470ef"
    sha256 cellar: :any_skip_relocation, monterey:       "f93cba7ab1a34fad7a7b147025958e827196b16a68925b62a1720c79a0f470ef"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9a8824d7d9a316c2e5482c0db3e42aaafaabd6c53f11508126b9fc2cc9b80b35"
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
