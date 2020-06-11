require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-9.1.8.tgz"
  sha256 "d508573f8120d628c97aa87b28bf81785cc64524e2045c277dae9de3456fe949"

  bottle do
    cellar :any_skip_relocation
    sha256 "7b148e8a96499ed9d928bf4f3ebcca8e57d65fd71072d16a2a77a782346f0c6f" => :catalina
    sha256 "13a51c5d82a43dd0b49fd5270fb5ec2a760866ef9a57874ba2ef301f3b28b25b" => :mojave
    sha256 "5cc352711daf44863b7cb46b8faf9c361f59656e26d77993d745070cea2f77f1" => :high_sierra
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
