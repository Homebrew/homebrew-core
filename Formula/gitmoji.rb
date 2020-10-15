require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.12.tgz"
  sha256 "04aa283b708f20c937011645df11dddf77be4f303158a4c5c67644dfb72cb379"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "613a40a0e837fb2299ac973af89533bf14f72506fcddadbc60f22d81fc5ba0a4" => :catalina
    sha256 "eead648be2ceecc788105e7e30342621a106e80935fb9c62232f0799c61d30d5" => :mojave
    sha256 "2b5cb87bce2c692545445078d8ea1bcdec555cdc39caafec19cc1654cf7bf4d5" => :high_sierra
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
