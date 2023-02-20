require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.14.0.tgz"
  sha256 "79906deadcc1c059a57dce43cbd9d16f2e26dea3039e40c08db940d983e05928"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "f9d3d71c56e1a5fb1ed4b6da4c9b5313f176fce1a7da417fb1537f5a09227186"
    sha256                               arm64_monterey: "ad9b83c1b47822fa52560443bf91cdc2870c3b6577a58ce25e82c36e2a9e61d6"
    sha256                               arm64_big_sur:  "bc6e429173afbe2220298fe4956944a0fee3d0cedbc3a1cfe975b732b1a756ae"
    sha256                               ventura:        "84e374a811084d23cdcc0ffb0ce99f554aff9ff9de96e15412745cb10988f017"
    sha256                               monterey:       "b2bda6f2de632f0ffa64648b33a629136db1e6f23d34f342d7e3516a762a790c"
    sha256                               big_sur:        "29fa9a4c4eca0df8ad714747932bf1a9caf6ea91cc10cae9d0a45ecf44546975"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "04e412defc606c301a1d495bb461bfd61ca8f2598804330e385ad54a7202e4ce"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match "Not logged in. Please log in to see site status.", shell_output("#{bin}/netlify status")
  end
end
