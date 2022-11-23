require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-15.0.1.tgz"
  sha256 "a75a8913987f0ca0cfe1028be10d74729aae64c2082f6d0cc1bd2cbada4f1c8a"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "53743b0e998ed51d8d73049877d576b6a2d6eeac39e19b07b8c3086dc4b1a593"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "53743b0e998ed51d8d73049877d576b6a2d6eeac39e19b07b8c3086dc4b1a593"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "53743b0e998ed51d8d73049877d576b6a2d6eeac39e19b07b8c3086dc4b1a593"
    sha256 cellar: :any_skip_relocation, monterey:       "35e83cabcc99270862576e431b29cc453455b54a1ec6294fd33e4df1af8e2b60"
    sha256 cellar: :any_skip_relocation, big_sur:        "35e83cabcc99270862576e431b29cc453455b54a1ec6294fd33e4df1af8e2b60"
    sha256 cellar: :any_skip_relocation, catalina:       "35e83cabcc99270862576e431b29cc453455b54a1ec6294fd33e4df1af8e2b60"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "53743b0e998ed51d8d73049877d576b6a2d6eeac39e19b07b8c3086dc4b1a593"
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
