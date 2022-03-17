require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.0.tgz"
  sha256 "88375412ac98d4dfbddfc0327dead44f1e361ebcf4bb21e9a1d5679a6c517154"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41a59baa130d301122c2f5498129eaf2f6897218594fa06c2b6ec2b25d2c0281"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41a59baa130d301122c2f5498129eaf2f6897218594fa06c2b6ec2b25d2c0281"
    sha256 cellar: :any_skip_relocation, monterey:       "9d94f31e2e454c5bb2597e845aa24df99f7b9f45d3a22d2fc1de3895017f6ffe"
    sha256 cellar: :any_skip_relocation, big_sur:        "9d94f31e2e454c5bb2597e845aa24df99f7b9f45d3a22d2fc1de3895017f6ffe"
    sha256 cellar: :any_skip_relocation, catalina:       "9d94f31e2e454c5bb2597e845aa24df99f7b9f45d3a22d2fc1de3895017f6ffe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41a59baa130d301122c2f5498129eaf2f6897218594fa06c2b6ec2b25d2c0281"
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
