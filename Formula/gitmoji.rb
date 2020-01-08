require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.1.0.tgz"
  sha256 "9dc50ec376d52e561faa11a1824585ab5511ec40653573a446ca0d2b47ae7333"

  bottle do
    cellar :any_skip_relocation
    sha256 "9254410f6e98034dcffa618547c79b241e31b0a9d6124d726f0ba9c5e637b046" => :catalina
    sha256 "1e529ccf9af26fe632f43587922dcc1fd4c02662a51b09fd73c01b4e1cd28830" => :mojave
    sha256 "6900c89d434b421418b94b81014a250e24d3288c89d0379080ddeedfeac8acca" => :high_sierra
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
