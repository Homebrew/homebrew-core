require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-16.2.5.tgz"
  sha256 "3d0b87ea225a5ac4e87c31e15940d6ca4fa3340bdd40990835e2ba8972d5ff41"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a5043113182fa5ed886d02b4d57df573743997b049656a8be83e364eac5f3e6f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a5043113182fa5ed886d02b4d57df573743997b049656a8be83e364eac5f3e6f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a5043113182fa5ed886d02b4d57df573743997b049656a8be83e364eac5f3e6f"
    sha256 cellar: :any_skip_relocation, sonoma:         "81778b9ab3bc9c483a5428b9f5ed46533b2cdb9793f3d1012c2a6e2cd94357e7"
    sha256 cellar: :any_skip_relocation, ventura:        "81778b9ab3bc9c483a5428b9f5ed46533b2cdb9793f3d1012c2a6e2cd94357e7"
    sha256 cellar: :any_skip_relocation, monterey:       "81778b9ab3bc9c483a5428b9f5ed46533b2cdb9793f3d1012c2a6e2cd94357e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a5043113182fa5ed886d02b4d57df573743997b049656a8be83e364eac5f3e6f"
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
