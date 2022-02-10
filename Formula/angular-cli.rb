require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-13.2.3.tgz"
  sha256 "b38d7375cf8e09947df053fb963cecf86387fc79bd7afb306ac4e2b5a9e2ddfc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5f42f2a7d89f5c69e3f50a9d64041e926004f3bfddda847a07119ee03a1c4949"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5f42f2a7d89f5c69e3f50a9d64041e926004f3bfddda847a07119ee03a1c4949"
    sha256 cellar: :any_skip_relocation, monterey:       "dee8027b3edada2bdec29d2b5b2eb5cc20ebb50b0700cdf8bbf5021ae0279e3f"
    sha256 cellar: :any_skip_relocation, big_sur:        "dee8027b3edada2bdec29d2b5b2eb5cc20ebb50b0700cdf8bbf5021ae0279e3f"
    sha256 cellar: :any_skip_relocation, catalina:       "dee8027b3edada2bdec29d2b5b2eb5cc20ebb50b0700cdf8bbf5021ae0279e3f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f42f2a7d89f5c69e3f50a9d64041e926004f3bfddda847a07119ee03a1c4949"
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
