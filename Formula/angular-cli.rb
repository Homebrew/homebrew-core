require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.1.tgz"
  sha256 "58c5cda8f2f8b6a08c13275d258ad12e0c59eb2001c452a540284dbc63c45d6c"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8ca72f9419ff56438bdc45bd18b9146b107bbe2fe220891b84bd0cb5a6002a96"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8ca72f9419ff56438bdc45bd18b9146b107bbe2fe220891b84bd0cb5a6002a96"
    sha256 cellar: :any_skip_relocation, monterey:       "f93abeb4d85f12222ca96aba49d6f23a1a88531b05793fc9988e6eef8c965164"
    sha256 cellar: :any_skip_relocation, big_sur:        "f93abeb4d85f12222ca96aba49d6f23a1a88531b05793fc9988e6eef8c965164"
    sha256 cellar: :any_skip_relocation, catalina:       "f93abeb4d85f12222ca96aba49d6f23a1a88531b05793fc9988e6eef8c965164"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8ca72f9419ff56438bdc45bd18b9146b107bbe2fe220891b84bd0cb5a6002a96"
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
