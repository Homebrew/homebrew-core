require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.6.tgz"
  sha256 "e10d84ee451f236e3be5ed487557c4b7bab46338d5115f5c58ecf4f6862b8bd6"

  bottle do
    cellar :any_skip_relocation
    sha256 "7c030356b17ad4be0b31fd9c5ac23caf55caff70090bb10cf09c0aa817011ee4" => :catalina
    sha256 "14f5a5ff84fcac29d63d1637cf34a2faf26541da273b5472214a999d6ad8db83" => :mojave
    sha256 "8ce45823d39099bdf652655ae4548471e9a4cc84b48f4a33f31e9ebf25467c38" => :high_sierra
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
