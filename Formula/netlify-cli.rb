require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-3.29.15.tgz"
  sha256 "16114f23fe56482f07c4186ccf982be1a23814513cd0e0a749a8f98ed21d0455"
  license "MIT"
  head "https://github.com/netlify/cli.git"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "958ba43a2e0bd8de73ed962fae979d90fa514181a20470b255256bbaea2f6190"
    sha256 cellar: :any_skip_relocation, big_sur:       "746935367087b2668e93f8ab3434b1d63fb72cae08c4c87e9578637bf462ba50"
    sha256 cellar: :any_skip_relocation, catalina:      "746935367087b2668e93f8ab3434b1d63fb72cae08c4c87e9578637bf462ba50"
    sha256 cellar: :any_skip_relocation, mojave:        "746935367087b2668e93f8ab3434b1d63fb72cae08c4c87e9578637bf462ba50"
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
