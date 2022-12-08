require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.0.3.tgz"
  sha256 "9dc258a4a37a71e2d83619bc4424fe959d22c452753f9b3001c4882e48b4535b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "f534d2f8a4306962449aa3bd4a230dd1be90402e0bf4e12c2c136a8bea0a305a"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f534d2f8a4306962449aa3bd4a230dd1be90402e0bf4e12c2c136a8bea0a305a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f534d2f8a4306962449aa3bd4a230dd1be90402e0bf4e12c2c136a8bea0a305a"
    sha256 cellar: :any_skip_relocation, ventura:        "a62f5964a1ea140865aede5995aaa2611825e798ee755c80d3eaeb89463f93ca"
    sha256 cellar: :any_skip_relocation, monterey:       "a62f5964a1ea140865aede5995aaa2611825e798ee755c80d3eaeb89463f93ca"
    sha256 cellar: :any_skip_relocation, big_sur:        "a62f5964a1ea140865aede5995aaa2611825e798ee755c80d3eaeb89463f93ca"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f534d2f8a4306962449aa3bd4a230dd1be90402e0bf4e12c2c136a8bea0a305a"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "angular-homebrew-test", "--skip-install"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
