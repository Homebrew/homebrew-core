require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.3.0.tgz"
  sha256 "1d1f6348eb693219792cdd42036ad26413e6609d7a237b083947aa189a92d88f"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2dddcc6663e00383bdb7b3f89c190df99766c69a6a36557a48ca3e2302627076"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2dddcc6663e00383bdb7b3f89c190df99766c69a6a36557a48ca3e2302627076"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "2dddcc6663e00383bdb7b3f89c190df99766c69a6a36557a48ca3e2302627076"
    sha256 cellar: :any_skip_relocation, ventura:        "79ec1d01be11a87936138a891b956bc0b56525e89645ff53aaf86afc22a215e2"
    sha256 cellar: :any_skip_relocation, monterey:       "79ec1d01be11a87936138a891b956bc0b56525e89645ff53aaf86afc22a215e2"
    sha256 cellar: :any_skip_relocation, big_sur:        "79ec1d01be11a87936138a891b956bc0b56525e89645ff53aaf86afc22a215e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2dddcc6663e00383bdb7b3f89c190df99766c69a6a36557a48ca3e2302627076"
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
