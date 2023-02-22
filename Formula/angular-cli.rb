require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.0.tgz"
  sha256 "694550884dfb82ffeeb25b9c9767175a4453a2bf3cba882cac75fd44d34ef8e9"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d91ddc7455c5d785faa7bf9dc0a0b0c786ec4dfb1c309f21cc4ed98cc4c3f091"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d91ddc7455c5d785faa7bf9dc0a0b0c786ec4dfb1c309f21cc4ed98cc4c3f091"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "d91ddc7455c5d785faa7bf9dc0a0b0c786ec4dfb1c309f21cc4ed98cc4c3f091"
    sha256 cellar: :any_skip_relocation, ventura:        "e4f978dcf642235b641fd62c4424c2c38344c9b179d6ccfcfde8122869c7f8a6"
    sha256 cellar: :any_skip_relocation, monterey:       "e4f978dcf642235b641fd62c4424c2c38344c9b179d6ccfcfde8122869c7f8a6"
    sha256 cellar: :any_skip_relocation, big_sur:        "b999d874dc8c77d06dc0489a2135c3f1694104d1a760c2d5de3c534ed012e663"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d91ddc7455c5d785faa7bf9dc0a0b0c786ec4dfb1c309f21cc4ed98cc4c3f091"
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
