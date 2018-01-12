require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-1.6.4.tgz"
  sha256 "8c97c54d541c9ef701fb81a900667fc4388b8d6eb5a09f61f780ef1b0a484df9"

  bottle do
    sha256 "3ad531c511f90e6cfac72c0fe323dea19b1eb98b0cdbc45b8e8875da0d8d74ad" => :high_sierra
    sha256 "a655c34817c7a0672295c7ec77fc9241fb3374f0eca322f8fe927f4d1dec70ac" => :sierra
    sha256 "5939626b70960ebde8fd98ff8a7979af4ca9014576a44c21b207943e70ab8929" => :el_capitan
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
