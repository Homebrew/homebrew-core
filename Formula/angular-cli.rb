require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.3.tgz"
  sha256 "d93062e1d5ae40cdb38b2453a48112407af715efcb61d6fcd5cc311421633868"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b69c0f6edd5011c6d48867f2ca0c88cca33371e9e08f4d53373a358814769d14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "b69c0f6edd5011c6d48867f2ca0c88cca33371e9e08f4d53373a358814769d14"
    sha256 cellar: :any_skip_relocation, monterey:       "67ce7e1f8215e61616c1b95790ac673cf0bffb9c3ceb7969b22084762a69a48c"
    sha256 cellar: :any_skip_relocation, big_sur:        "67ce7e1f8215e61616c1b95790ac673cf0bffb9c3ceb7969b22084762a69a48c"
    sha256 cellar: :any_skip_relocation, catalina:       "67ce7e1f8215e61616c1b95790ac673cf0bffb9c3ceb7969b22084762a69a48c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b69c0f6edd5011c6d48867f2ca0c88cca33371e9e08f4d53373a358814769d14"
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
