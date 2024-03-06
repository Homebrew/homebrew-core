require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-3.1.44.tgz"
  sha256 "7acafe992dee313fda1b10c29c5bb4b94c8390b6326894a7d5b02c186f5a7d94"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "e73cb2531f46fa2c700be6447515f72e6387c9d9ba1b63f2a7cf11c2ed7a57cb"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e73cb2531f46fa2c700be6447515f72e6387c9d9ba1b63f2a7cf11c2ed7a57cb"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e73cb2531f46fa2c700be6447515f72e6387c9d9ba1b63f2a7cf11c2ed7a57cb"
    sha256 cellar: :any_skip_relocation, sonoma:         "fba8aad20c9eddf857cacf751365f2bd01120fea604fd287ba0fbc80d81b250e"
    sha256 cellar: :any_skip_relocation, ventura:        "fba8aad20c9eddf857cacf751365f2bd01120fea604fd287ba0fbc80d81b250e"
    sha256 cellar: :any_skip_relocation, monterey:       "fba8aad20c9eddf857cacf751365f2bd01120fea604fd287ba0fbc80d81b250e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e73cb2531f46fa2c700be6447515f72e6387c9d9ba1b63f2a7cf11c2ed7a57cb"
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
