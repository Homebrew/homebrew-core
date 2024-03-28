require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.2.tgz"
  sha256 "18518ad4e53dae7e86d1cb18da4f486e138b3c9d09ce6c6c3fcd2f4c95f6ba35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "50292a637ade873372bf639b0417dd6abcf0577636c8bf6fddea0ebe4ca27c37"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "50292a637ade873372bf639b0417dd6abcf0577636c8bf6fddea0ebe4ca27c37"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "50292a637ade873372bf639b0417dd6abcf0577636c8bf6fddea0ebe4ca27c37"
    sha256 cellar: :any_skip_relocation, sonoma:         "2e37b05977b42636be85d3db5f2ba68fe5c02b3efe2ee981f901b0035b6d68b9"
    sha256 cellar: :any_skip_relocation, ventura:        "2e37b05977b42636be85d3db5f2ba68fe5c02b3efe2ee981f901b0035b6d68b9"
    sha256 cellar: :any_skip_relocation, monterey:       "2e37b05977b42636be85d3db5f2ba68fe5c02b3efe2ee981f901b0035b6d68b9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "50292a637ade873372bf639b0417dd6abcf0577636c8bf6fddea0ebe4ca27c37"
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
