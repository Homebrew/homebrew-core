require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.5.tgz"
  sha256 "5bfced9f44f696f87c4ecf974029a3ef3c1603360f21d838eb41c4d64998cbac"

  bottle do
    sha256 "56acd43b753f7bed412650fc235e5cd25c2f08a7aa223f22f21d40d63fb90aa4" => :high_sierra
    sha256 "f588f2940f91a6034370773737c594cb7bd778eb543fa3f69d0a9d6d53837af5" => :sierra
    sha256 "389211c53d0651890c4c159d02a508695686c1e1a57dd79044380311cbe146be" => :el_capitan
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
