require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.2.0.tgz"
  sha256 "b4b9404a287105964c96f10ac108de9f9a4491e6f2418ab906847b546c512e02"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d931b79e7b4b46903020c179ef21c416764c35107b189160e8cf42f697c60fc0"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "d931b79e7b4b46903020c179ef21c416764c35107b189160e8cf42f697c60fc0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "d931b79e7b4b46903020c179ef21c416764c35107b189160e8cf42f697c60fc0"
    sha256 cellar: :any_skip_relocation, sonoma:         "a840375d699d1f771d193526af28ad02aabaeb9fe01e45b7fe2fe3c1cdf66963"
    sha256 cellar: :any_skip_relocation, ventura:        "a840375d699d1f771d193526af28ad02aabaeb9fe01e45b7fe2fe3c1cdf66963"
    sha256 cellar: :any_skip_relocation, monterey:       "a840375d699d1f771d193526af28ad02aabaeb9fe01e45b7fe2fe3c1cdf66963"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d931b79e7b4b46903020c179ef21c416764c35107b189160e8cf42f697c60fc0"
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
