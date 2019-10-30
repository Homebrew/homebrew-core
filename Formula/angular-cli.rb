require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-8.3.16.tgz"
  sha256 "d6223017a437a92920d0b0586a035cc2c15bc7cb5e0e89ece974f40585998cb4"

  bottle do
    cellar :any_skip_relocation
    sha256 "621a968a8ce3eaf3e925bbed918c4fd2bce4f5375038fd092de17ea384be2ce6" => :catalina
    sha256 "093dce1e9935ebc0b34a3ecd69c1aefb3efb626e17cf0a9416b94e84a652817d" => :mojave
    sha256 "16e2e6e2537126143454b6b62025f7c6106e27e86d63bf8dc1319b86758c7b4b" => :high_sierra
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
