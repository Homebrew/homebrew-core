require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-12.1.4.tgz"
  sha256 "b03715f3a65ba9806ade010764956257fad1de131711b9f95e1b099159f4f913"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "5ca8f15d73f12ed1ffc4954890a7d146070052f9ff20a117b5d53968cb200ddf"
    sha256 cellar: :any_skip_relocation, big_sur:       "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, catalina:      "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, mojave:        "02b0917f66a03ca32840de73daa3651fd311dbb6d8f14f0456405d0121100e07"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "5ca8f15d73f12ed1ffc4954890a7d146070052f9ff20a117b5d53968cb200ddf"
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
