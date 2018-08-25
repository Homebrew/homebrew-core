require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.1.5.tgz"
  sha256 "5c33dc17b37354f93da7087e3019031cb87ade290e6cb9a515f31cbb3301cca5"

  bottle do
    sha256 "5ab20db2e52cdb3130aad7cd7acd550f08eeaf491b78e76f1e2a0e3c652b86a4" => :high_sierra
    sha256 "8f8b7697107f27b0b450ba5c30f030acc004ae783aaabdfd6a9f64b8c8e98ad6" => :sierra
    sha256 "138bb6cace2526a4fdb77b567ced66521c8b3227b957ae0b162d03e7c2dfe03f" => :el_capitan
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
