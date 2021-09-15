require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.5.tgz"
  sha256 "b536d1949b898610b7ad0ddb6b6da8dd16ec78f49d78133573a285892fb14ab9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "6bc7ec9fa317be7634aa5a4dabc6ee822aad92ea9533c4486d7d50c01a222627"
    sha256 cellar: :any_skip_relocation, big_sur:       "2895f1df6e87df3f443eb9b5a35046b63153de0fbe7c8959ad5daeed35107375"
    sha256 cellar: :any_skip_relocation, catalina:      "2895f1df6e87df3f443eb9b5a35046b63153de0fbe7c8959ad5daeed35107375"
    sha256 cellar: :any_skip_relocation, mojave:        "2895f1df6e87df3f443eb9b5a35046b63153de0fbe7c8959ad5daeed35107375"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "6bc7ec9fa317be7634aa5a4dabc6ee822aad92ea9533c4486d7d50c01a222627"
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
