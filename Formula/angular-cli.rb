require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.0.0.tgz"
  sha256 "f47449cf2a36acec44de4e8baafd6b27f72ab69f227f69ad5722bc85a9ee0d1e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5867f79cb18c8d46f8670bd2882d6df49e506a0b367f0169e4445eb5af9ee666"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5867f79cb18c8d46f8670bd2882d6df49e506a0b367f0169e4445eb5af9ee666"
    sha256 cellar: :any_skip_relocation, monterey:       "312bfa830af6f0fc40366ac7b77a41959efbf5a2f34f8aee18abccf40c2d147a"
    sha256 cellar: :any_skip_relocation, big_sur:        "312bfa830af6f0fc40366ac7b77a41959efbf5a2f34f8aee18abccf40c2d147a"
    sha256 cellar: :any_skip_relocation, catalina:       "312bfa830af6f0fc40366ac7b77a41959efbf5a2f34f8aee18abccf40c2d147a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5867f79cb18c8d46f8670bd2882d6df49e506a0b367f0169e4445eb5af9ee666"
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
