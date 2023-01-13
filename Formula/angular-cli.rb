require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.1.tgz"
  sha256 "12aade63c90bbe9ff8c93a0761a069e5790d8fecaf8b511c3748f2db1471e96a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "c0a32ae7480739f298c31628e62e4857faeb26ee7c3ba53f231c631ad3fff4fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "c0a32ae7480739f298c31628e62e4857faeb26ee7c3ba53f231c631ad3fff4fc"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "c0a32ae7480739f298c31628e62e4857faeb26ee7c3ba53f231c631ad3fff4fc"
    sha256 cellar: :any_skip_relocation, ventura:        "dd562aab219d79b695b4b5b269cda6a4083416c979be329b5e98cb833c729ee2"
    sha256 cellar: :any_skip_relocation, monterey:       "dd562aab219d79b695b4b5b269cda6a4083416c979be329b5e98cb833c729ee2"
    sha256 cellar: :any_skip_relocation, big_sur:        "dd562aab219d79b695b4b5b269cda6a4083416c979be329b5e98cb833c729ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c0a32ae7480739f298c31628e62e4857faeb26ee7c3ba53f231c631ad3fff4fc"
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
