require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-6.12.0.tgz"
  sha256 "5d50210d00e014e15b61c6bf901cd1a1df973100e3f11b8bfb09f846f6ddf169"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_big_sur: "e5e49410aec85501d158de1d6bada6b21aa318727e4364a6b52c19d595615d45"
    sha256 cellar: :any_skip_relocation, big_sur:       "0380a8cbb304af9dfd2e2d0a29834e9a25a44bad286e042c68268cab53219ce6"
    sha256 cellar: :any_skip_relocation, catalina:      "0380a8cbb304af9dfd2e2d0a29834e9a25a44bad286e042c68268cab53219ce6"
    sha256 cellar: :any_skip_relocation, mojave:        "ad5545c6e2bd421344790411151b9f0fbe5ed56989ea093c4ed41c1b09005f87"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "0618344c90cf79ecc7567f2de1abf97d85903cfd794b50edc5811b0b39c551f1"
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
