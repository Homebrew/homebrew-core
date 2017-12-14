require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.1.tgz"
  sha256 "d677248cc41c73116120965d4bcb09e1525219f3768250dabdf3b13313adf923"

  bottle do
    sha256 "6510329fcfad270c73e5580b5a75ed23553c86dc31d3c6ba136a4785feaa75de" => :high_sierra
    sha256 "ee2e4dab0d2cb7cf6a2a581ca9c50a2ea9bf7d716d63db0e54639694fd2f6aa7" => :sierra
    sha256 "560ffde60f7126446ac421383a354aa4ca23ea9e3ae7a848483fcaeb6c043048" => :el_capitan
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
