require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-15.4.1.tgz"
  sha256 "04997973cbc75db97fbdd21f1f5dee6bf070bce9f0b08f5d7d5d3aa8bbe51e92"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256                               arm64_ventura:  "cf88ab5588e8b201ee7e4226290701302856e5b37b1410122452b8c1d07a5a05"
    sha256                               arm64_monterey: "45e22c1bee496c511f40b3e8dc27744e679cac536ff0111beacc325c053a6dba"
    sha256                               arm64_big_sur:  "568da2d074f0c22e16e453e2a57717016dc23727bfbcbf77d5eed78987683773"
    sha256                               ventura:        "cb5798c70b8b622e9155db6b92febf1ef2a61b38094512554ee592d3aa7f5012"
    sha256                               monterey:       "3924cf85e3b6462695a2a3e5f497c3974458a1568c5a38e2e07dc6e6cde91e1f"
    sha256                               big_sur:        "ff517262da927692a9b9b76ae60ce2e4c653f1ec55c5d38ed0f64111b9f70db0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "21aad4c4afb328d1fe9e72dedca43d78337cad776a47888a942ad6108a002754"
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
