require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.10.0.tgz"
  sha256 "04f76a7b53a431a26d50bf139c720ae499d88f74ba32894a735788b740462225"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "18ed393fc4afe3887be7d80a83d2db5de1401c0391943a84100cae827a0a0c3e"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "18ed393fc4afe3887be7d80a83d2db5de1401c0391943a84100cae827a0a0c3e"
    sha256 cellar: :any_skip_relocation, monterey:       "6cbe016dcc04210a9857d8021eae42f9fb69a9b8a228c248faf3d004ac37a4c4"
    sha256 cellar: :any_skip_relocation, big_sur:        "6cbe016dcc04210a9857d8021eae42f9fb69a9b8a228c248faf3d004ac37a4c4"
    sha256 cellar: :any_skip_relocation, catalina:       "6cbe016dcc04210a9857d8021eae42f9fb69a9b8a228c248faf3d004ac37a4c4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5087e1797192f7c7bcb7444c493e66b2aa85ee0cd9f8fcd6d3f2a5b515e5c054"
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
