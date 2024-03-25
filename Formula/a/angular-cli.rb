require "language/node"

class AngularCli < Formula
  desc "CLI tool for Angular"
  homepage "https://cli.angular.io/"
  url "https://registry.npmjs.org/@angular/cli/-/cli-17.3.2.tgz"
  sha256 "18518ad4e53dae7e86d1cb18da4f486e138b3c9d09ce6c6c3fcd2f4c95f6ba35"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "cb6d0be6a361367ee2693667baa2120d118a2b96d02d5e8c6e2fe16d63692383"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cb6d0be6a361367ee2693667baa2120d118a2b96d02d5e8c6e2fe16d63692383"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "cb6d0be6a361367ee2693667baa2120d118a2b96d02d5e8c6e2fe16d63692383"
    sha256 cellar: :any_skip_relocation, sonoma:         "8cb01bc0deb22ed2db8fd3a6d274bf22e6ab9c413c37de821b3df509865bc254"
    sha256 cellar: :any_skip_relocation, ventura:        "8cb01bc0deb22ed2db8fd3a6d274bf22e6ab9c413c37de821b3df509865bc254"
    sha256 cellar: :any_skip_relocation, monterey:       "8cb01bc0deb22ed2db8fd3a6d274bf22e6ab9c413c37de821b3df509865bc254"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cb6d0be6a361367ee2693667baa2120d118a2b96d02d5e8c6e2fe16d63692383"
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
