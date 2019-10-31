require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.16.tgz"
  sha256 "d6223017a437a92920d0b0586a035cc2c15bc7cb5e0e89ece974f40585998cb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "25947b9a3630c357dc8021b430ec2f8e99923b0f3da7cea687f8fd7af8d23e9f" => :catalina
    sha256 "0d3ab4f2dc042eb8cd52e1986cd2ac7890b6cdc1890d102fbb28f78cd51449f1" => :mojave
    sha256 "76ca680f95dc866a175c85da5b682eaca8d52facb3f019c432f09f7b91ab1ee3" => :high_sierra
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
