require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.2.tgz"
  sha256 "861fc3f5be1dbc102428ce9d0ee7b18ee5520cc4f5f06e3573bfd2b4e446c1d0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b7d154158339e6142ee451074cdb73fa59a4c4b2f70d92c44214db0ad5886120"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b7d154158339e6142ee451074cdb73fa59a4c4b2f70d92c44214db0ad5886120"
    sha256 cellar: :any_skip_relocation, monterey:       "16b7261d18cdb4ed169da52c897903268fe87df8bb90ab9af6c50f422a5fe9a4"
    sha256 cellar: :any_skip_relocation, big_sur:        "16b7261d18cdb4ed169da52c897903268fe87df8bb90ab9af6c50f422a5fe9a4"
    sha256 cellar: :any_skip_relocation, catalina:       "16b7261d18cdb4ed169da52c897903268fe87df8bb90ab9af6c50f422a5fe9a4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b7d154158339e6142ee451074cdb73fa59a4c4b2f70d92c44214db0ad5886120"
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
