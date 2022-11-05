require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-12.1.0.tgz"
  sha256 "bd3f477d97d99e0e4b8bd0471458581ea209c8d012714ac915d831801eb75e96"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "5ac41a7e5a184f6e9ba6dcdc4d131b332bf15ad0499331ddb05c271b526236ea"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "5ac41a7e5a184f6e9ba6dcdc4d131b332bf15ad0499331ddb05c271b526236ea"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "5ac41a7e5a184f6e9ba6dcdc4d131b332bf15ad0499331ddb05c271b526236ea"
    sha256 cellar: :any_skip_relocation, monterey:       "a9975de227d7f8da9876b7fd91812c623513c3acb730476387de1b0ec4645e6b"
    sha256 cellar: :any_skip_relocation, big_sur:        "a9975de227d7f8da9876b7fd91812c623513c3acb730476387de1b0ec4645e6b"
    sha256 cellar: :any_skip_relocation, catalina:       "a9975de227d7f8da9876b7fd91812c623513c3acb730476387de1b0ec4645e6b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "d431e654cfd2342c8b46305d8899337826b94dd1d6e418c1af206f033c49db30"
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
