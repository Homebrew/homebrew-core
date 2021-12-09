require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.1.0.tgz"
  sha256 "0f5bd4520853ff1c6d1603ce68ae4c59913e3ad90b14c0d36ba829404b14a509"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "638b86d7d4a7f0b3fdb4404244f046f8c8688708c45131994ef67045bcd35d90"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "638b86d7d4a7f0b3fdb4404244f046f8c8688708c45131994ef67045bcd35d90"
    sha256 cellar: :any_skip_relocation, monterey:       "591f044f9e661cd5f156a7beb0254d4cdc3bd67154cfb4bf794f47944c681701"
    sha256 cellar: :any_skip_relocation, big_sur:        "591f044f9e661cd5f156a7beb0254d4cdc3bd67154cfb4bf794f47944c681701"
    sha256 cellar: :any_skip_relocation, catalina:       "591f044f9e661cd5f156a7beb0254d4cdc3bd67154cfb4bf794f47944c681701"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "638b86d7d4a7f0b3fdb4404244f046f8c8688708c45131994ef67045bcd35d90"
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
