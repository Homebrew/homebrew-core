require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.2.6.tgz"
  sha256 "87568c5169f9ca913de29d9c699286c27cf4402fb2c4224ad6480f5c92093895"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "ff4b16deffaaf87751e58be10fc90512e67b551d08ebd6093d6a1f2dbcdfdef1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "ff4b16deffaaf87751e58be10fc90512e67b551d08ebd6093d6a1f2dbcdfdef1"
    sha256 cellar: :any_skip_relocation, monterey:       "78ebbd4fc6592a185dd8852565e6793a46914a8165ed58d1d46938065e620baa"
    sha256 cellar: :any_skip_relocation, big_sur:        "78ebbd4fc6592a185dd8852565e6793a46914a8165ed58d1d46938065e620baa"
    sha256 cellar: :any_skip_relocation, catalina:       "78ebbd4fc6592a185dd8852565e6793a46914a8165ed58d1d46938065e620baa"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff4b16deffaaf87751e58be10fc90512e67b551d08ebd6093d6a1f2dbcdfdef1"
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
