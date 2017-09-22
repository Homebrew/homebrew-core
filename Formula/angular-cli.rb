require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.3.tgz"
  sha256 "e95b42158365982b7b5106b02699c2ebf8d8edee818bb57d40fda5a5a3ade9ef"

  bottle do
    sha256 "4cd03c1dd54dbc40048d9fc21fd070317ca3b6daf008418811945301f9927278" => :high_sierra
    sha256 "e41733ad33fd0f2e56869b8503feeeefceeb329090f190704051496d41b17f61" => :sierra
    sha256 "6ecff2c702a684fa5b3ad1ff1e5dae77f1586d26098820dfc4ac073d5068336d" => :el_capitan
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
