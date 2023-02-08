require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.5.tgz"
  sha256 "963dd683c4f1d89f8080076188cf06b3760dff9c61ae0f9d5688ccca4f3365d7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e5616860ad9c744e8fdb4c2b9b560c67c3262f1cea34097beed7fe5a11233139"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e5616860ad9c744e8fdb4c2b9b560c67c3262f1cea34097beed7fe5a11233139"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e5616860ad9c744e8fdb4c2b9b560c67c3262f1cea34097beed7fe5a11233139"
    sha256 cellar: :any_skip_relocation, ventura:        "ba8d86a0517341233425433e104a63ca3343488d06b2a3809d5cd56d86c3435d"
    sha256 cellar: :any_skip_relocation, monterey:       "ba8d86a0517341233425433e104a63ca3343488d06b2a3809d5cd56d86c3435d"
    sha256 cellar: :any_skip_relocation, big_sur:        "ba8d86a0517341233425433e104a63ca3343488d06b2a3809d5cd56d86c3435d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e5616860ad9c744e8fdb4c2b9b560c67c3262f1cea34097beed7fe5a11233139"
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
