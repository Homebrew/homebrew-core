require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.2.3.tgz"
  sha256 "b3da2c9fef5183d335c765e580b50d3f1b7d6516e2629897c0e4e58f45c1a55e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "3cda2aba0d687ac5282614e93e8b5031f3cece6b9abc86c976a4d11e6c3df8b6"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "3cda2aba0d687ac5282614e93e8b5031f3cece6b9abc86c976a4d11e6c3df8b6"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3cda2aba0d687ac5282614e93e8b5031f3cece6b9abc86c976a4d11e6c3df8b6"
    sha256 cellar: :any_skip_relocation, sonoma:         "b54e1874eea1065e7cc739a35df0e8f6ba13d7207dd3135e987c0977bf4d26bf"
    sha256 cellar: :any_skip_relocation, ventura:        "b54e1874eea1065e7cc739a35df0e8f6ba13d7207dd3135e987c0977bf4d26bf"
    sha256 cellar: :any_skip_relocation, monterey:       "b54e1874eea1065e7cc739a35df0e8f6ba13d7207dd3135e987c0977bf4d26bf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3cda2aba0d687ac5282614e93e8b5031f3cece6b9abc86c976a4d11e6c3df8b6"
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
