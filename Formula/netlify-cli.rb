require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.2.2.tgz"
  sha256 "3f1f8adb48aa58fa7e9d7e7ad5f871804344d61c4f17f7ef982e70329548783a"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "48c72fa0e63fbab754fd20ade021e7ba5baa030f5c1bdb5228407c38758843ea" => :big_sur
    sha256 "65e37ad1b01e4d2de31863fad47468b0a573b57410d2727e628ad3c72f634c1e" => :arm64_big_sur
    sha256 "9a1dc906cf18f3a9bcbb6807eb3356dac0e6329e895a173b745fdc9b2b17f159" => :catalina
    sha256 "5642afff3772465efea1635e68049c33d67e708b89ea3da77f2354315658137b" => :mojave
  end

  depends_on "node"

  uses_from_macos "expect" => :test

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
