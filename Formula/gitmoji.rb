require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-2.0.0.tgz"
  sha256 "0ef8353bc2f7f75b1c4d3185563751510d8020ee0efc5299bdaa309e82b475bf"

  bottle do
    cellar :any_skip_relocation
    sha256 "2520aa4b9f4c36ad69cc2e9f839aa3fdd96981c1ea8169d33dc3eaa87045034b" => :catalina
    sha256 "6b2c31ac2f823b68115535e2ac56b5c67c13d31b437b3fb4500e68a1402e4e1c" => :mojave
    sha256 "820ac0d24d76fa93b447b30cc44336b7d87eff9a7e87445473498c638a9ca406" => :high_sierra
    sha256 "a89b26d70faf179e5fafea1429d4ab8096f797491d85e4f010ba3b21f7543985" => :sierra
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
