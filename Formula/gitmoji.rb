require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.5.tgz"
  sha256 "970160cb1bd7215542906ca22495f970bc0eb39e3ec995d9f57f03cdeaf738e2"

  bottle do
    cellar :any_skip_relocation
    sha256 "90e581500a8e7d19ab593cffa338569c0cd4c068baef1f67b445ff8d33c2a169" => :catalina
    sha256 "76be7fc3791f2ec81209b8726f1b4b4a0221b9a8872dc190c26f725cc3b51ab7" => :mojave
    sha256 "2a1141d9e92b724bdb5bfffc626cc0eca0d4306cefa758712268c996bc434105" => :high_sierra
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
