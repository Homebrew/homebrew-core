require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-11.1.2.tgz"
  sha256 "2e6480247737dc5d56aaf3636cb93c191898e7ef127b70b6de345370d1c8e59d"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "f3824bf9e5c190fc99256f1a1dfba9efa491ccdcf012f66eca3fc6c14824ee58"
    sha256 cellar: :any_skip_relocation, big_sur:       "c96d55ed7c2f82d28d572e65562e99814477d09b3cc930e909f31c406fbb87d3"
    sha256 cellar: :any_skip_relocation, catalina:      "9febe14fd6fe7b71741e9ea8f7c17f9a4ab859be47010548c98337136e49212b"
    sha256 cellar: :any_skip_relocation, mojave:        "d7dca1604074adeb804922ef99406b36db56ee793729ad2b4d5e89ab7896eea5"
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
