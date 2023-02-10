require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.12.0.tgz"
  sha256 "681d703f2e858ce4ca8eba8c3a24fa9003fe3c2e2e19c422a9b59492a22d7d12"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "2642c1fe959eaeceaccd0a64af1dfc4c265d9d8baf225dfd31d1b75e611f5716"
    sha256                               arm64_monterey: "475785e3bcb3a16997119cc254e634a3624505b5e59e96d7713959ef660799b1"
    sha256                               arm64_big_sur:  "6757cd3c8fcae9b81b51d851a78432ae05ade21461783756170bd9728055a141"
    sha256                               ventura:        "705fd4a05e5b7937386ac18d3c9227c0a65e6eb03b329a645d51445225c3ccba"
    sha256                               monterey:       "bb8791108f6b4a5c12b8277bcc1b07b9bf1d248e28b7e2f72079bdfbfd3c9369"
    sha256                               big_sur:        "c378449a441e2fa80a0edf45b4957cc1a99d9eb6848b9dcfea5e137caad15305"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "c6aed5e71195c25a70cf65c29f5ef28f7dabed4b320bf223aef9e898e579e828"
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
