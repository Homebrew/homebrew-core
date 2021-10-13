require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.9.tgz"
  sha256 "e5a46cec9a4ef03fa81d1e28d84d804764aaa883ea2a389c0f879cd28cc380b4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "314061254aa2b19cd01b55048bab532b1e8c19302d9f90a0c54e60cbc46dad17"
    sha256 cellar: :any_skip_relocation, big_sur:       "9871ad4cf10dfc315d5e612031fd5a498a88530a747bad0752cc9e6ae781db5c"
    sha256 cellar: :any_skip_relocation, catalina:      "9871ad4cf10dfc315d5e612031fd5a498a88530a747bad0752cc9e6ae781db5c"
    sha256 cellar: :any_skip_relocation, mojave:        "9871ad4cf10dfc315d5e612031fd5a498a88530a747bad0752cc9e6ae781db5c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "314061254aa2b19cd01b55048bab532b1e8c19302d9f90a0c54e60cbc46dad17"
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
