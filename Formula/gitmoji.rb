require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.1.tgz"
  sha256 "c0031d926c07ecfb3d03b27b0f26ed9c2711749015f5766109e87bfac1e6791b"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "385246ee625614e22f59422efd70a2e1af31d84ca41556c8be39dc21dcd06a2f"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "385246ee625614e22f59422efd70a2e1af31d84ca41556c8be39dc21dcd06a2f"
    sha256 cellar: :any_skip_relocation, monterey:       "d4445a3365a84dd6f4b8da87d19b5fc6adec4311100896bfb9f67002da21b586"
    sha256 cellar: :any_skip_relocation, big_sur:        "d4445a3365a84dd6f4b8da87d19b5fc6adec4311100896bfb9f67002da21b586"
    sha256 cellar: :any_skip_relocation, catalina:       "d4445a3365a84dd6f4b8da87d19b5fc6adec4311100896bfb9f67002da21b586"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "385246ee625614e22f59422efd70a2e1af31d84ca41556c8be39dc21dcd06a2f"
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
