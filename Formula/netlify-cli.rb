require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.5.0.tgz"
  sha256 "cf6a433519783e7a5448b1405814d96e84f897295b7d8348cfccb87c55d53a58"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "9c102656dcc08d30251f1724e96e395187394e8ebe30f5481dc11309e6d74818"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "9c102656dcc08d30251f1724e96e395187394e8ebe30f5481dc11309e6d74818"
    sha256 cellar: :any_skip_relocation, monterey:       "f26bf235b36e82f5b834364323a881feb10ea13d26435998c5341d2d1826686f"
    sha256 cellar: :any_skip_relocation, big_sur:        "f26bf235b36e82f5b834364323a881feb10ea13d26435998c5341d2d1826686f"
    sha256 cellar: :any_skip_relocation, catalina:       "f26bf235b36e82f5b834364323a881feb10ea13d26435998c5341d2d1826686f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "47a91cd6de56d37c8f3a0dd80f2f0cdf5542d029c54872e168d6de5b797b65fa"
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
