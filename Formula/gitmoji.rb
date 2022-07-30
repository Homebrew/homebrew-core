require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.3.tgz"
  sha256 "8575c951a89aa5bf5727c8146fd1bdf04418685564de780888abd53deb0f16f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f883ef1e1e92398e8d250a06ccd03fef28522b3ba5f2d3b0ba807decb52f9477"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f883ef1e1e92398e8d250a06ccd03fef28522b3ba5f2d3b0ba807decb52f9477"
    sha256 cellar: :any_skip_relocation, monterey:       "e22e66c9a81f6d33ea0d548cf51421a0f4175bc605a69fafa877e108c47e3b6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e22e66c9a81f6d33ea0d548cf51421a0f4175bc605a69fafa877e108c47e3b6b"
    sha256 cellar: :any_skip_relocation, catalina:       "e22e66c9a81f6d33ea0d548cf51421a0f4175bc605a69fafa877e108c47e3b6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f883ef1e1e92398e8d250a06ccd03fef28522b3ba5f2d3b0ba807decb52f9477"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
