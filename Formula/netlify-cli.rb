require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.59.1.tgz"
  sha256 "fac6ed595bcf61082ed19fbf8461349ae44c37fcfd6dfcba87cc8d5e04051128"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  livecheck do
    url :stable
  end

  bottle do
    cellar :any_skip_relocation
    sha256 "5ab24d2d5e87e765add3687f8d4f3e03adfbd44bc3b3627002a665ee303342c1" => :catalina
    sha256 "9c3853f56042300174efcf0b4d66b5807a035c5d6897a538651a537d529e688b" => :mojave
    sha256 "e8bf65b2b9f01f0785a0774be9ff508eed42de8eb376ff9d86f2e203cb79bcaf" => :high_sierra
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
