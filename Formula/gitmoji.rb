require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-2.2.0.tgz"
  sha256 "4e6e78010029c2f9abfc978aa84acd36125dca72ec9f7708d1d5060b03a43618"

  bottle do
    cellar :any_skip_relocation
    sha256 "8d5dbbc9eb543d922390a4dbec9f585572b867cf194257cfc4b41d782eb05736" => :catalina
    sha256 "6c63be94c0c9fb0e482d0f949ad9c379f50b535f8a31f76fe89bd8f534a746d5" => :mojave
    sha256 "8baf4327e73999498512255a19618d051de978a62e4c1aa89ba322df7e90b7bb" => :high_sierra
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
