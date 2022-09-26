require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-6.3.0.tgz"
  sha256 "cdb9980f9e419a08dfc9e8c390cc1d516a4ee33e2976f170a916653b25ed6bc7"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "41c2698c623b154b84589b544b9f18e570ffb247b0ff3eba940c3e3ac9083aad"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "41c2698c623b154b84589b544b9f18e570ffb247b0ff3eba940c3e3ac9083aad"
    sha256 cellar: :any_skip_relocation, monterey:       "aedddd1e073b5333e82d00a2615b95432dc865b03cad268c0007d2038069fd86"
    sha256 cellar: :any_skip_relocation, big_sur:        "aedddd1e073b5333e82d00a2615b95432dc865b03cad268c0007d2038069fd86"
    sha256 cellar: :any_skip_relocation, catalina:       "aedddd1e073b5333e82d00a2615b95432dc865b03cad268c0007d2038069fd86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "41c2698c623b154b84589b544b9f18e570ffb247b0ff3eba940c3e3ac9083aad"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match ":bug:", shell_output("#{bin}/gitmoji --search bug")
  end
end
