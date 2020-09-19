require "language/node"

class Gitmoji < Formula
  desc "Emoji guide for your commit messages"
  homepage "https://gitmoji.carloscuesta.me"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-3.2.11.tgz"
  sha256 "f34ce2092132696c5ae7057344aa451211cc1de1e4a04e47f5f118c521a1da2b"
  license "MIT"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "3bc51deec77805917251ad49cc8f9b8627e6e7d99e160bf3baf7f6a1610b1c24" => :catalina
    sha256 "734716c626550a1ee92bc55d12ea6763127b0d24e1e0afa4503a1cd264c64590" => :mojave
    sha256 "ee4c52f05ac8abfcd789b349a0825835c4b39db28e3404c62adc45b94bd53da3" => :high_sierra
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
