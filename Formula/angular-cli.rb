require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.1.tgz"
  sha256 "1514350b48c34d2774cca5c70ce4bdb430f309a11954d78e9b784075dea146ed"

  bottle do
    sha256 "cd4d003b02631afb3afa03b6a97512b2bc973f7250babafbf8256759ebd19cba" => :sierra
    sha256 "903db861d06ae6da3f729d754763f9ea2d738287a26a2c2a22e0b9f899661521" => :el_capitan
    sha256 "fc611377f911bcf4adde5c67624b1a9c1c94b5cc8bfea9f2b9f819bf6a284562" => :yosemite
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert File.exist?("angular-homebrew-test/package.json"), "Project was not created"
  end
end
