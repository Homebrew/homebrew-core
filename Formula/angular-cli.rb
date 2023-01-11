require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.0.tgz"
  sha256 "fc320c75ba802ce9e6c8512e88507175f2a4ec4ee72d3294e22912477693b01f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "744c3fb1db77a5f95cee1c325b370eccd7185147cf8089796925835f342f0a2c"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "744c3fb1db77a5f95cee1c325b370eccd7185147cf8089796925835f342f0a2c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "744c3fb1db77a5f95cee1c325b370eccd7185147cf8089796925835f342f0a2c"
    sha256 cellar: :any_skip_relocation, ventura:        "74d6de46cbecab42bd7c04213a2cf590c2159994727b74a27ed6fa32d089f0d8"
    sha256 cellar: :any_skip_relocation, monterey:       "74d6de46cbecab42bd7c04213a2cf590c2159994727b74a27ed6fa32d089f0d8"
    sha256 cellar: :any_skip_relocation, big_sur:        "74d6de46cbecab42bd7c04213a2cf590c2159994727b74a27ed6fa32d089f0d8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "744c3fb1db77a5f95cee1c325b370eccd7185147cf8089796925835f342f0a2c"
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
