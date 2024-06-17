require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://angular.dev/cli"
  url "https://registry.npmjs.org/@angular/cli/-/cli-18.0.4.tgz"
  sha256 "7450ab4e0629187bd1ad59b108a7a48acadbe2969d9e3f1e563a49e5a1fb8e35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2836408e706cea3c3de85619b2223eeb8ab0999932c1c06c4c1ab61cceb3c0ed"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2836408e706cea3c3de85619b2223eeb8ab0999932c1c06c4c1ab61cceb3c0ed"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2836408e706cea3c3de85619b2223eeb8ab0999932c1c06c4c1ab61cceb3c0ed"
    sha256 cellar: :any_skip_relocation, sonoma:         "013b338552c53ac18f4e2253173d00114e3e46507aeb308b941d2a4061d752f4"
    sha256 cellar: :any_skip_relocation, ventura:        "013b338552c53ac18f4e2253173d00114e3e46507aeb308b941d2a4061d752f4"
    sha256 cellar: :any_skip_relocation, monterey:       "013b338552c53ac18f4e2253173d00114e3e46507aeb308b941d2a4061d752f4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "0a767b2dc76371dd7760cd1bd8c7087c904b10266f0c73ea7461e86333e21771"
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
