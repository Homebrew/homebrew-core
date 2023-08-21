require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.0.tgz"
  sha256 "aeff48ae81b7959733e81656bc42a4902fafc7fbcf28f8b071b345c23cef3b40"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
    sha256 cellar: :any_skip_relocation, ventura:        "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, monterey:       "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, big_sur:        "580b6efc4c730a841eddae07553d91074b83e9493282b441d7a72e4fd903dc5e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ac4e553f17b29246f59a0ca694a1c74fe03a681afbafa502f82c2605e9a9dbbd"
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
