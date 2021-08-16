require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.1.tgz"
  sha256 "dbb7a9230621c16ee7724fb1003e6aa87b6dffe8a221c76ebb1361af14332cfa"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "8d06aec44800e6638c5a69f77f3576af5b8cb80385357aa844dd391aad7c24bb"
    sha256 cellar: :any_skip_relocation, big_sur:       "031fa51025ec6b2ff0dc26486d3b8d0935981609dd4ec4dbdd0e5aa77230e3d7"
    sha256 cellar: :any_skip_relocation, catalina:      "031fa51025ec6b2ff0dc26486d3b8d0935981609dd4ec4dbdd0e5aa77230e3d7"
    sha256 cellar: :any_skip_relocation, mojave:        "031fa51025ec6b2ff0dc26486d3b8d0935981609dd4ec4dbdd0e5aa77230e3d7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8d06aec44800e6638c5a69f77f3576af5b8cb80385357aa844dd391aad7c24bb"
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
