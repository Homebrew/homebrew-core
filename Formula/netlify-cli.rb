require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.14.5.tgz"
  sha256 "91d540f01f6539fc62af296972c01ee79f092b86fed7c10404b016a27db7e759"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "230fe43322ea9d33b74216eec7c9703c85a697dacc4251c6ff5781df17187301"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "7cbedb4ee73ad42b870a1621b0a235762faa9826698175c173c9febd444049ec"
    sha256 cellar: :any_skip_relocation, monterey:       "7831eb6dec0a92bbe661da8cee38b6b2c3054ce7ae3f7fd1ad42132678fffdb8"
    sha256 cellar: :any_skip_relocation, big_sur:        "6a2e4dab657b6cc5f29bdc474dc796ba83d311713ea88edffb47cd14ed30b452"
    sha256 cellar: :any_skip_relocation, catalina:       "6a2e4dab657b6cc5f29bdc474dc796ba83d311713ea88edffb47cd14ed30b452"
    sha256 cellar: :any_skip_relocation, mojave:         "6a2e4dab657b6cc5f29bdc474dc796ba83d311713ea88edffb47cd14ed30b452"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1162f49754ca03e4dacaa374697419721181e3b7bd850d833a3ad319da52bba6"
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
