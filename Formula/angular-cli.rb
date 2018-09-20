require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-6.2.3.tgz"
  sha256 "395b87da466d6018620d1dfd2fc962432d64771c55d1a11da28a55fe42d54ba2"

  bottle do
    sha256 "72df38b81b7157d0940e2a617a6f7994decb40840b71ec536c07b15c9d63869f" => :mojave
    sha256 "e15a2e6370d31c79a8de9789da26ea8b4242cb5166ae6ec59729647c863e9e81" => :high_sierra
    sha256 "b32cc55ab18eae9dba4f9c2f233c6e50b21ac59bc79d8cfe8d46064ec7d1dbba" => :sierra
    sha256 "5b5c2b26333203399023ad6835424ef75c84c0c4136b49533cef670a0565c31a" => :el_capitan
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
