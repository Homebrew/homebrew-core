require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.1.0.tgz"
  sha256 "cf88762cf490696a2e827d37cbe5360b59cc39f74247e5dd50f63ef6b80fe5ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "c8e957fa523582b355c9092eb7f146d7920c37b949bd9369210f35655182c4e8"
    sha256 cellar: :any_skip_relocation, big_sur:       "602a2b4c2dbd47f16285be5637913c08602e65f09d4bbbd5c4f1d6cf01fad272"
    sha256 cellar: :any_skip_relocation, catalina:      "602a2b4c2dbd47f16285be5637913c08602e65f09d4bbbd5c4f1d6cf01fad272"
    sha256 cellar: :any_skip_relocation, mojave:        "602a2b4c2dbd47f16285be5637913c08602e65f09d4bbbd5c4f1d6cf01fad272"
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
