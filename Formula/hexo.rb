require "language/node"

class Hexo < Formula
  desc "A fast, simple & powerful blog framework"
  homepage "https://hexo.io/"
  url "https://registry.npmjs.org/hexo/-/hexo-5.2.0.tgz"
  sha256 "3356e9c498af656e0f4fc34673fb8106b33ac6b0d0565efe00fff796bcadc1c8"
  license "MIT"
  head "https://github.com/hexojs/hexo.git"

  livecheck do
    url :stable
  end

  depends_on "node"

  def install
    mkdir_p libexec/"lib"
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/hexo --help")
    assert_match "Usage: hexo <command>", output.strip
  end
end
