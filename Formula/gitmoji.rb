require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.3.1.tgz"
  sha256 "2e17e36c161d04d825c8aafb47114f5d6cf6dd3344cddb24859ad1f1dd321249"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "8929687ecf3ab2982b1122b787fd46bd061833c210c1fef333050a9c23524b48"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "8929687ecf3ab2982b1122b787fd46bd061833c210c1fef333050a9c23524b48"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "8929687ecf3ab2982b1122b787fd46bd061833c210c1fef333050a9c23524b48"
    sha256 cellar: :any_skip_relocation, ventura:        "e47f811b73c17b72aee5a6ccb5c7fbfdf835131637d644a00b60aac2b5b2d98b"
    sha256 cellar: :any_skip_relocation, monterey:       "e47f811b73c17b72aee5a6ccb5c7fbfdf835131637d644a00b60aac2b5b2d98b"
    sha256 cellar: :any_skip_relocation, big_sur:        "e47f811b73c17b72aee5a6ccb5c7fbfdf835131637d644a00b60aac2b5b2d98b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "8929687ecf3ab2982b1122b787fd46bd061833c210c1fef333050a9c23524b48"
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
