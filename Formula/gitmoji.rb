require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-4.1.0.tgz"
  sha256 "cf88762cf490696a2e827d37cbe5360b59cc39f74247e5dd50f63ef6b80fe5ca"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "36fc0144eca05465602192d0c950af928b681f133fb811fbabf7f803d00eeeb0"
    sha256 cellar: :any_skip_relocation, big_sur:       "6765dbbe0a51578a8a508949b5ab96693c7cb46c384e1bb4fd0b8fdc5f5639f8"
    sha256 cellar: :any_skip_relocation, catalina:      "6765dbbe0a51578a8a508949b5ab96693c7cb46c384e1bb4fd0b8fdc5f5639f8"
    sha256 cellar: :any_skip_relocation, mojave:        "6765dbbe0a51578a8a508949b5ab96693c7cb46c384e1bb4fd0b8fdc5f5639f8"
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
