require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.15.30.tgz"
  sha256 "d1d8231f41759aae4300042fcbef210fa3221088dcd5ca61d1face6d010b61f4"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "08623743c15ddf0d32b19a328f74c7f241a16efdea2f1592b509e720f4372079"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "0d838bb75afc9c0bb3a95df15e8fd201afb4e39757a762e9420da9b13ec8333a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "0d838bb75afc9c0bb3a95df15e8fd201afb4e39757a762e9420da9b13ec8333a"
    sha256 cellar: :any_skip_relocation, monterey:       "c299e6160becf21fbf8e4ef1ca170f4533f098d889af250125a3a2df0e4ef997"
    sha256 cellar: :any_skip_relocation, big_sur:        "c299e6160becf21fbf8e4ef1ca170f4533f098d889af250125a3a2df0e4ef997"
    sha256 cellar: :any_skip_relocation, catalina:       "c299e6160becf21fbf8e4ef1ca170f4533f098d889af250125a3a2df0e4ef997"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0d838bb75afc9c0bb3a95df15e8fd201afb4e39757a762e9420da9b13ec8333a"
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
