require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.14.10.tgz"
  sha256 "c18d64ee6189610983f8c0b06c6efebe0a4345536d8d222d8c3c975e36ea50bb"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f8a2b350affc359cf710edc3f968ea6849274878221d216af5aadf3b88e01248"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f8a2b350affc359cf710edc3f968ea6849274878221d216af5aadf3b88e01248"
    sha256 cellar: :any_skip_relocation, monterey:       "fca7e04f025fdcdf4da9564dde9f4d3ea6b15bc87c202f1789efd701269d145e"
    sha256 cellar: :any_skip_relocation, big_sur:        "fca7e04f025fdcdf4da9564dde9f4d3ea6b15bc87c202f1789efd701269d145e"
    sha256 cellar: :any_skip_relocation, catalina:       "fca7e04f025fdcdf4da9564dde9f4d3ea6b15bc87c202f1789efd701269d145e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f8a2b350affc359cf710edc3f968ea6849274878221d216af5aadf3b88e01248"
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
