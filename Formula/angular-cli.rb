require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.8.tgz"
  sha256 "c6d598565e8e9cd8971e62b759805960748281ed735ae12f1778fa5762d0bb97"

  bottle do
    cellar :any_skip_relocation
    sha256 "74a6cfe4f8f3058331c0c30723e28a47ca0e4619dbef97ef2a307446d591dd4a" => :catalina
    sha256 "d6c3db5eca9124a124efc0b27c19198a11be4ae2f083b4fdd6cbd302409cd8cd" => :mojave
    sha256 "28916c378fea7b1199354b5417f4567fd183a2174dc8ce45b6c26bfe6d9b0c42" => :high_sierra
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
