require "language/node"

class Lerna < Formula
  desc "Tool for managing JavaScript projects with multiple packages"
  homepage "https://lerna.js.org"
  url "https://registry.npmjs.org/lerna/-/lerna-5.1.8.tgz"
  sha256 "96a2982e085ac6aa6966a71a615143f37ca923b80eb79c232cafcfe2594f8b2e"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "848bd852dff3144fbb64e86d2360e7fdf48956cad43d2db8f6ab07a2ec32cbf0"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "3c83fd1b45bedae4abee157231b5fe78331ac14948e3e99c183a71eda10ce4d0"
    sha256 cellar: :any_skip_relocation, ventura:        "e543b304f8cae65e7910c34ad9199b350a0fc4b47be6ce062e9402abde4f4d0c"
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
