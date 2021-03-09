require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.3.0.tgz"
  sha256 "b781d6154580833fbd13f4ad543fcc0cd4815683d4a6a108a7ba0fc0f9cd2dbe"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "3128a06278d85ea1d54b718866a32e78d9fd424372fe2023648e6139d6477832"
    sha256 cellar: :any_skip_relocation, big_sur:       "7bb76cec02ceae5df03280cd50bf8f06776b24cdb0cd1e9ae2995f6fefe6cff5"
    sha256 cellar: :any_skip_relocation, catalina:      "43c16a44087dd58059c1b4d3d5cdd401663bcd0d1328f4c412062465dc738f51"
    sha256 cellar: :any_skip_relocation, mojave:        "ab44b3fe5e4951c3e96b4ea47b15dac769ede3449668e3e0f66ecd59a5af7687"
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
