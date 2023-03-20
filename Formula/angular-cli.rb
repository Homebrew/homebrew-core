require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.2.4.tgz"
  sha256 "a634c7cc4106968b6d5b5feac3e944ed783bb826229ccde76e395a0f8841e977"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "e81909abf60701462c1aeba3256a79c9e78dd63c0733f4998924cee013b0c1a0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "e81909abf60701462c1aeba3256a79c9e78dd63c0733f4998924cee013b0c1a0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "e81909abf60701462c1aeba3256a79c9e78dd63c0733f4998924cee013b0c1a0"
    sha256 cellar: :any_skip_relocation, ventura:        "9e59d936ae77a0ae9142ef1f84d005e443273344ccf60fe574d35289bfe749e0"
    sha256 cellar: :any_skip_relocation, monterey:       "9e59d936ae77a0ae9142ef1f84d005e443273344ccf60fe574d35289bfe749e0"
    sha256 cellar: :any_skip_relocation, big_sur:        "9e59d936ae77a0ae9142ef1f84d005e443273344ccf60fe574d35289bfe749e0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e81909abf60701462c1aeba3256a79c9e78dd63c0733f4998924cee013b0c1a0"
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
