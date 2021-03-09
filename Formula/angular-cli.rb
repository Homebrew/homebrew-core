require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.2.3.tgz"
  sha256 "178de352a3a546bdf88cff345844cf6ab928789c57061ee0a5ef508b7e73ee22"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8a7c28fcf03b9c986a18182b8b6ae2809495d19f14647a4f106dc97ec75ced67"
    sha256 cellar: :any_skip_relocation, big_sur:       "99f5a5341b8089dc0a38568ae4c63b5d2f272054e7cb9aba26b1b3b594e83595"
    sha256 cellar: :any_skip_relocation, catalina:      "808fcec69d0f8bccad9651844e28577dc75109d2980550ebf36f5b6616e27f99"
    sha256 cellar: :any_skip_relocation, mojave:        "daa08e5ca2e2c9e20c10c502b15e8ca81a2b582592fb00ded6697bbecaa33f3a"
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
