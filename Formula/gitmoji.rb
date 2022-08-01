require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.3.tgz"
  sha256 "8575c951a89aa5bf5727c8146fd1bdf04418685564de780888abd53deb0f16f4"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a03269e25f3b1a0745da7f140493a09158ad9a41b52c2b80cad4d7129a973e14"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "a03269e25f3b1a0745da7f140493a09158ad9a41b52c2b80cad4d7129a973e14"
    sha256 cellar: :any_skip_relocation, monterey:       "203999357e8f7c5c151ff95b75146b5d407c10fad31f0f086a9678acb91962a9"
    sha256 cellar: :any_skip_relocation, big_sur:        "203999357e8f7c5c151ff95b75146b5d407c10fad31f0f086a9678acb91962a9"
    sha256 cellar: :any_skip_relocation, catalina:       "203999357e8f7c5c151ff95b75146b5d407c10fad31f0f086a9678acb91962a9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a03269e25f3b1a0745da7f140493a09158ad9a41b52c2b80cad4d7129a973e14"
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
