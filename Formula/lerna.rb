require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.5.0.tgz"
  sha256 "7642a30189b315236fe9e8c83ec451e78a48629884552394e4b6d89fbd502ffc"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, monterey:       "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, big_sur:        "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, catalina:       "a6c8f333fd0d643184f63379826daf456f29566fd754393fd3330837abf93d6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/lerna --version")

    output = shell_output("#{bin}/lerna init --independent 2>&1")
    assert_match "lerna success Initialized Lerna files", output
  end
end
