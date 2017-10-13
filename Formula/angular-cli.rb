require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.4.7.tgz"
  sha256 "3727fbd7893f20bf076dd7dc7aad685369f40c7e67568ec88614d5eb3c7f3c49"

  bottle do
    sha256 "b3e451bc5c862cc671ccbd1e0cbb9f3e4b8ebd8a7a1195a7c20111ae09585e96" => :high_sierra
    sha256 "b780b065cf87d7b6d3244923e8d951896e0f41372dc5aaf94a4180e428c886b6" => :sierra
    sha256 "6fc69aea3367fb56888d4377d79c01f380bd08fd3b44ea70f6e98a8c809bef20" => :el_capitan
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"ng", "new", "--skip-install", "angular-homebrew-test"
    assert_predicate testpath/"angular-homebrew-test/package.json", :exist?, "Project was not created"
  end
end
