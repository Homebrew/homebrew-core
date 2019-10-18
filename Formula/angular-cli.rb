require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.12.tgz"
  sha256 "8f8004a05a3dad1cd9a123dc07e15f7c274a5ba2255b5350e044c92bb0ff5d40"

  bottle do
    cellar :any_skip_relocation
    sha256 "c7218f1f40127e93d53e3c5ed2f3a8eee80b87f368b359f90a13f9cdde0d8647" => :catalina
    sha256 "1a5d905d504ef0c0dbc2dc6eee875f73b51d9db95369423d188d46469636f1f7" => :mojave
    sha256 "c71e619cde2d52ae81a95ab6c83fcab497b5f86bb481efe641ecde2c66ec1eaa" => :high_sierra
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
