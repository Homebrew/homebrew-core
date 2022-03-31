require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.3.1.tgz"
  sha256 "98cca5d8aa40addedb055173ac5865f9c2579d7abe5b67c7637e5702a31fdf4d"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "fee607d4a4d745700ca10d8cea040d6226c7f2fe4a184e05159525bf991a11e9"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "fee607d4a4d745700ca10d8cea040d6226c7f2fe4a184e05159525bf991a11e9"
    sha256 cellar: :any_skip_relocation, monterey:       "d19ac24d34ba90fce80f8e59124a3e23d423f1c4685eeb106e5030b72f5621f8"
    sha256 cellar: :any_skip_relocation, big_sur:        "d19ac24d34ba90fce80f8e59124a3e23d423f1c4685eeb106e5030b72f5621f8"
    sha256 cellar: :any_skip_relocation, catalina:       "d19ac24d34ba90fce80f8e59124a3e23d423f1c4685eeb106e5030b72f5621f8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fee607d4a4d745700ca10d8cea040d6226c7f2fe4a184e05159525bf991a11e9"
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
