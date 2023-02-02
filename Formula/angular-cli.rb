require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.4.tgz"
  sha256 "d6eade4d005239c264da4ae59a86db0c1703ad06b2366f97c12898372e63d4e1"
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
