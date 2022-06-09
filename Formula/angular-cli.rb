require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.1.tgz"
  sha256 "5de1fd1422cd2a47a6ff6eb5d195fea90bfae368cc73921aa1593a4d751557b8"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8fea871f6e108c353deebbe49289136128f2766edbbb710da49f44948f531da6"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8fea871f6e108c353deebbe49289136128f2766edbbb710da49f44948f531da6"
    sha256 cellar: :any_skip_relocation, monterey:       "4bf0a4312da39bccf55f84dcc2b8d56de1b34111c290cd003b85c1b948060725"
    sha256 cellar: :any_skip_relocation, big_sur:        "4bf0a4312da39bccf55f84dcc2b8d56de1b34111c290cd003b85c1b948060725"
    sha256 cellar: :any_skip_relocation, catalina:       "4bf0a4312da39bccf55f84dcc2b8d56de1b34111c290cd003b85c1b948060725"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8fea871f6e108c353deebbe49289136128f2766edbbb710da49f44948f531da6"
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
