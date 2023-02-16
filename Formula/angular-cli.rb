require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.1.6.tgz"
  sha256 "31d8339e968eec16a90009c5442518b767fd2ba9332bcb7391ae7aee77fb0b50"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5d2b87dd5d0e465403f69147f5656d725e99af60a04e694d55a09c00450d03e3"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "843560d5844be02379e9014edac376aca896af487c93c26f35a7b373a12bb5e2"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f346abbd62cba1c2f9900d1a561c1b1476fd2437466cdc98407f4a563c83789e"
    sha256 cellar: :any_skip_relocation, ventura:        "3b7d511dfffe29638f6feb8423b4f0ff204475d7ef17a605bc292c7a428b36dc"
    sha256 cellar: :any_skip_relocation, monterey:       "8aaa91763e35deff5dfcc40933171786939cfc7c3d762fd11345d612220911ec"
    sha256 cellar: :any_skip_relocation, big_sur:        "1e03182f9ffe7ce27105a788e751a949e2a749c03df10b40a945d8dd2e171abe"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4a1d3c8ad92d9699eab5d2857262cf69381beb821856b15fdaaa30b9a23164c4"
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
