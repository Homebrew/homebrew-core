require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-14.0.5.tgz"
  sha256 "fa50804b1515140f5bef2c3527c33e259b5a2a5114bf658d97360b7f422c14d4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c0880a5614bea73c79987e417d24e95ee9b9417454d967a929fe2e0e57df88a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c0880a5614bea73c79987e417d24e95ee9b9417454d967a929fe2e0e57df88a"
    sha256 cellar: :any_skip_relocation, monterey:       "1f574f531eee2a4f32002414fef17b6a527a0932ad57ed238e729979b39b1390"
    sha256 cellar: :any_skip_relocation, big_sur:        "1f574f531eee2a4f32002414fef17b6a527a0932ad57ed238e729979b39b1390"
    sha256 cellar: :any_skip_relocation, catalina:       "1f574f531eee2a4f32002414fef17b6a527a0932ad57ed238e729979b39b1390"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9c0880a5614bea73c79987e417d24e95ee9b9417454d967a929fe2e0e57df88a"
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
