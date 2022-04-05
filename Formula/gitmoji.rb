require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.12.0.tgz"
  sha256 "f40d74b81f11479989a098931290c9a0bf980cce35defdb6473d037b296ea9e3"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "4271f8cf26321aaf7a56513c67eba3d7c5bef758bfee4c7c1be75c36c8d741b3"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4271f8cf26321aaf7a56513c67eba3d7c5bef758bfee4c7c1be75c36c8d741b3"
    sha256 cellar: :any_skip_relocation, monterey:       "b45be48d12718535d6b1d51b47c2df33277d5dbd2c7ff184fb65135a3ba03caf"
    sha256 cellar: :any_skip_relocation, big_sur:        "b45be48d12718535d6b1d51b47c2df33277d5dbd2c7ff184fb65135a3ba03caf"
    sha256 cellar: :any_skip_relocation, catalina:       "b45be48d12718535d6b1d51b47c2df33277d5dbd2c7ff184fb65135a3ba03caf"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "4271f8cf26321aaf7a56513c67eba3d7c5bef758bfee4c7c1be75c36c8d741b3"
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
