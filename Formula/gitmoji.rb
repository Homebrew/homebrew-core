require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.4.1.tgz"
  sha256 "ad2dcf00b4bb6a974e9157ad1b5438b118cb6b3a523f9d6400a4dc137ca630e5"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "1f9444231dc2f632bf1e1e63c0a1ccf4c65dc76c509bc5580bd03b7876df5a2d"
    sha256 cellar: :any_skip_relocation, big_sur:       "9e8eb70a097e8e39ecffd474bca1320df9ec682e49426abe0ae97e56ebacb89e"
    sha256 cellar: :any_skip_relocation, catalina:      "9e8eb70a097e8e39ecffd474bca1320df9ec682e49426abe0ae97e56ebacb89e"
    sha256 cellar: :any_skip_relocation, mojave:        "9e8eb70a097e8e39ecffd474bca1320df9ec682e49426abe0ae97e56ebacb89e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "1f9444231dc2f632bf1e1e63c0a1ccf4c65dc76c509bc5580bd03b7876df5a2d"
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
