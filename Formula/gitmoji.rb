require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-1.9.3.tgz"
  sha256 "0db7e36e06f758f00750d17cce379c775f889a777b7b960af9043f3a0c0d5c2e"

  bottle do
    cellar :any_skip_relocation
    sha256 "0d5422f5826853668f7569f0432802002121310d1366bbe242eba10597748880" => :mojave
    sha256 "1af7d249877bd94bb7621ba548662e2efdb1ca1609913ffc0b905681f15ae755" => :high_sierra
    sha256 "4a7776ff24ba52035f0514af5e1c5847ff287f313214d36edf93580182eb1cbe" => :sierra
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
