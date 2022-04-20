require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-5.0.0.tgz"
  sha256 "53359e86afaea0519f8956db1e121b8cee1a3fa2d83bd3b9239a67b478a01fb2"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "f681d6949ea935980dc21221e49cba4769dff8d8b566b985707879cc9572d8b8"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "f681d6949ea935980dc21221e49cba4769dff8d8b566b985707879cc9572d8b8"
    sha256 cellar: :any_skip_relocation, monterey:       "782c1a6c6761e505799703f32c515c1ead946cf321649eac04bd704f441d038c"
    sha256 cellar: :any_skip_relocation, big_sur:        "782c1a6c6761e505799703f32c515c1ead946cf321649eac04bd704f441d038c"
    sha256 cellar: :any_skip_relocation, catalina:       "782c1a6c6761e505799703f32c515c1ead946cf321649eac04bd704f441d038c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f681d6949ea935980dc21221e49cba4769dff8d8b566b985707879cc9572d8b8"
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
