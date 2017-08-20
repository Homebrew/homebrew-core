require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.3.1.tgz"
  sha256 "1514350b48c34d2774cca5c70ce4bdb430f309a11954d78e9b784075dea146ed"

  bottle do
    sha256 "07484b8f7fb28d403d34d6774445b964208421ed7306016b0f962c077832321a" => :sierra
    sha256 "e8087941413556ad3131cbcce7f1f1fbc3c8359839b111e00431f423ac2a7dd4" => :el_capitan
    sha256 "e47f0251bf6d122b3c172ef92357389b9321dbcae1bed1f30b88de351d32983c" => :yosemite
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
