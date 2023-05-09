require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.0.1.tgz"
  sha256 "d89adce519c288651131f702a15df6637bbe9e6e1f8c172fae72823ca667c541"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "6999b72060dd39c070873d27813130e8bd8bcf66ad5ca00f4578745f102c9e50"
    sha256                               arm64_monterey: "718d1408662d514ae5a574965d91d9b783ff9a11ed79bdf4c5f0b74848b291b0"
    sha256                               arm64_big_sur:  "2dac42ab8f69685662f164ae7f0d7fc4370fea1d3a5aa0a06826b9fd6004498d"
    sha256                               ventura:        "8d85bafbe54b0f55a1607767248b97675573d3646712da237175a37d9b4b7175"
    sha256                               monterey:       "7de23fcb49d54210971a19f9694e69416ccbff10e20f968ce4265e596bff1678"
    sha256                               big_sur:        "4e73489a1b82e5039defdc28192fb9a264a2bfdc9ebd926e42f2777bf40b3703"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ee373a46214ad74e5ab7a342169f7be7f491a3551cca685ce09387ce228c9730"
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
