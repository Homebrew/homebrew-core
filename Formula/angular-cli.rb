require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.2.0.tgz"
  sha256 "1e6a66259a9b759838f3df4ba5efd0ecee7c7ea98e35f1698bb7681551ac29ec"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f021832535f5cd550f74ab6f88a82a194dcbe23e0377199f768d2db7b923362e"
    sha256 cellar: :any_skip_relocation, big_sur:       "5a2cef2473837506454ff2d117ee5311f6fd2586eb2ac8d7a72f93f9adeee060"
    sha256 cellar: :any_skip_relocation, catalina:      "5a2cef2473837506454ff2d117ee5311f6fd2586eb2ac8d7a72f93f9adeee060"
    sha256 cellar: :any_skip_relocation, mojave:        "5a2cef2473837506454ff2d117ee5311f6fd2586eb2ac8d7a72f93f9adeee060"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f021832535f5cd550f74ab6f88a82a194dcbe23e0377199f768d2db7b923362e"
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
