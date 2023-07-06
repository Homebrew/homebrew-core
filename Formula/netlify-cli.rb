require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.8.1.tgz"
  sha256 "6fee363bb744d39868648a128836861facfda701e64ec080239805e38246a48c"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "009ef12c794996a4ab1fa1281ce669da9e1d7f1d203aaaf55d1989245fa4b55f"
    sha256                               arm64_monterey: "698433288ea5e0b1e92fa01bb480327338c29f5368e3ec526890db1e811fad8a"
    sha256                               arm64_big_sur:  "e9e8a72475847a1609c55942b40fb2be8ed362ac3f545b424c248af8a75c9e65"
    sha256                               ventura:        "9da6a2475b6b2114188e674f39be4f81fd03e9661df0f7471b240efe977920bf"
    sha256                               monterey:       "d2b2fbc3fb51cd5834d305f9aa29b913aa75a25ab5593856d0664fa50e5945ea"
    sha256                               big_sur:        "6e4be7b7dd343c0704e6e08e7f5cbd2e239af65142ac17f9df5b5fa31f591db3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a373134b056281aed2908db4d80fbc6c5a006c52d5353de17c789b5cfec49e85"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
