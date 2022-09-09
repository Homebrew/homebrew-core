require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-11.6.0.tgz"
  sha256 "45a40d993089bf1cb3ee084526bb248eff926e055c1d2b422b6b625c5dfa365a"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "31bdbda81dc187fecb6c8eae98dd4c9d590611c54121dd9c98a1fc3a88766c9c"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "31bdbda81dc187fecb6c8eae98dd4c9d590611c54121dd9c98a1fc3a88766c9c"
    sha256 cellar: :any_skip_relocation, monterey:       "6d20afebc42cb07efc57a128ab546dda6546e33ff4e9989964e49762dffda300"
    sha256 cellar: :any_skip_relocation, big_sur:        "6d20afebc42cb07efc57a128ab546dda6546e33ff4e9989964e49762dffda300"
    sha256 cellar: :any_skip_relocation, catalina:       "6d20afebc42cb07efc57a128ab546dda6546e33ff4e9989964e49762dffda300"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ff2bd75af670a34e2160cbdfb2d51109d95cea9a0d80b3c0d88db304a81d7c91"
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
