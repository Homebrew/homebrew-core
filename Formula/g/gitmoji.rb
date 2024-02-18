require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-9.1.0.tgz"
  sha256 "d55d7fcb00551c23446a93d52367da64effd7361bfbeb75445f7e588d83577be"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "199c718a205424ad652e14c40375e4ef9b7c7e6609183395318fcd8ca1be3f66"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "199c718a205424ad652e14c40375e4ef9b7c7e6609183395318fcd8ca1be3f66"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "199c718a205424ad652e14c40375e4ef9b7c7e6609183395318fcd8ca1be3f66"
    sha256 cellar: :any_skip_relocation, sonoma:         "5c5fe3c35a14457bf063d72c12ff2ab2c27058c4a349a7279cb71b50846a26e7"
    sha256 cellar: :any_skip_relocation, ventura:        "5c5fe3c35a14457bf063d72c12ff2ab2c27058c4a349a7279cb71b50846a26e7"
    sha256 cellar: :any_skip_relocation, monterey:       "5c5fe3c35a14457bf063d72c12ff2ab2c27058c4a349a7279cb71b50846a26e7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "199c718a205424ad652e14c40375e4ef9b7c7e6609183395318fcd8ca1be3f66"
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
