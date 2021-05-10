require "language/node"

class ContentfulCli < Formula
  desc "Contentful command-line tools"
  homepage "https://github.com/contentful/contentful-cli"
  url "https://registry.npmjs.org/contentful-cli/-/contentful-cli-1.6.20.tgz"
  sha256 "62aa112a73c57e74c75cb78f1422e61f23439e4af984643fa2f7139fcfcfcd82"
  license "MIT"
  head "https://github.com/contentful/contentful-cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "cc644e23bde48c10564803f9a32802022d22df567fda1910cecbeb376703441f"
    sha256 cellar: :any_skip_relocation, big_sur:       "535a042edb06cde645de78badd76bcac05ce9df39380caa8a632da4450ddc539"
    sha256 cellar: :any_skip_relocation, catalina:      "535a042edb06cde645de78badd76bcac05ce9df39380caa8a632da4450ddc539"
    sha256 cellar: :any_skip_relocation, mojave:        "535a042edb06cde645de78badd76bcac05ce9df39380caa8a632da4450ddc539"
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
