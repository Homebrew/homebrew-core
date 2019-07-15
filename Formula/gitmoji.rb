require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-1.9.3.tgz"
  sha256 "0db7e36e06f758f00750d17cce379c775f889a777b7b960af9043f3a0c0d5c2e"
  bottle do
    cellar :any_skip_relocation
    sha256 "809f082f95b3ba8a3fb85557313556e94e6e730f6bf27bfb590ae96e7f431140" => :mojave
    sha256 "9f254dfce3f33088a04924771633cc724dae7686ee80ae9ddd3c13542da2a614" => :high_sierra
    sha256 "9bfb1c3478817213c023ed69a644dfd0446662f6045f0e34a383e3b91126c2dd" => :sierra
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
