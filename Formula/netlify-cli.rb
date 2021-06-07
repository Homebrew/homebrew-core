require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.35.6.tgz"
  sha256 "cd1f4fafa42be0354bff93df9d42390bbc3bfa06cb392b7b75f32f5d5c40c7b6"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "b53ff3b061e4a7f8fde0f2b0f5f1e0660cdffa0419a0e2387448fb2186a8eedb"
    sha256 cellar: :any_skip_relocation, big_sur:       "3033a6290c59150a02805e0eadc47e9736093ca60f592567388d00349d422030"
    sha256 cellar: :any_skip_relocation, catalina:      "3033a6290c59150a02805e0eadc47e9736093ca60f592567388d00349d422030"
    sha256 cellar: :any_skip_relocation, mojave:        "3033a6290c59150a02805e0eadc47e9736093ca60f592567388d00349d422030"
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
