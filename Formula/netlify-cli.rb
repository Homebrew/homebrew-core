require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-10.0.0.tgz"
  sha256 "6b4e4ad3eedcadda9ea0328f76055e18e5a151dedba0cb566b335ecb3c2d4556"
  license "MIT"
  head "https://github.com/netlify/cli.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "6df8d664bf527da02698e2b6680f6444f8b6c330cff26021f9821fb89e3d01b1"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6df8d664bf527da02698e2b6680f6444f8b6c330cff26021f9821fb89e3d01b1"
    sha256 cellar: :any_skip_relocation, monterey:       "88ee7b67925ade08231cee209384e4fa581ed926d24da8296757dca0f2294459"
    sha256 cellar: :any_skip_relocation, big_sur:        "88ee7b67925ade08231cee209384e4fa581ed926d24da8296757dca0f2294459"
    sha256 cellar: :any_skip_relocation, catalina:       "88ee7b67925ade08231cee209384e4fa581ed926d24da8296757dca0f2294459"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "169779e007cc1a12f4471de4891cafe79ea082e06f05453acaf62324efc1ac5b"
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
