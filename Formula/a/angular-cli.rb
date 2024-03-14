require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.0.tgz"
  sha256 "c6b916439d28d1ed3b02729ea5b28e92d0f2df0254a3f5d6c372a53570abfee0"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "235f570d3473b2bc5c91ac9622c9d83ddda67b2f37ba18b8e2f0b5bab07d7076"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "235f570d3473b2bc5c91ac9622c9d83ddda67b2f37ba18b8e2f0b5bab07d7076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "235f570d3473b2bc5c91ac9622c9d83ddda67b2f37ba18b8e2f0b5bab07d7076"
    sha256 cellar: :any_skip_relocation, sonoma:         "a3f2efb2b183997da98e3ec489d72a9272fa8c69db85b3a9b235796ddf380b6a"
    sha256 cellar: :any_skip_relocation, ventura:        "a3f2efb2b183997da98e3ec489d72a9272fa8c69db85b3a9b235796ddf380b6a"
    sha256 cellar: :any_skip_relocation, monterey:       "a3f2efb2b183997da98e3ec489d72a9272fa8c69db85b3a9b235796ddf380b6a"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "235f570d3473b2bc5c91ac9622c9d83ddda67b2f37ba18b8e2f0b5bab07d7076"
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
