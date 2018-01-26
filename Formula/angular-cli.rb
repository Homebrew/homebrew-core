require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.6.tgz"
  sha256 "96477e357732ac5b29580ddc2467f919ad412af4ee63e2404ac83cba43ddec23"

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
