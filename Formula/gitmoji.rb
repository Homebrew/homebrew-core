require "language/node"

class Gitmoji < Formula
  desc "Interactive command-line tool for using emoji in commit messages"
  homepage "https://gitmoji.dev"
  url "https://registry.npmjs.org/gitmoji-cli/-/gitmoji-cli-8.0.0.tgz"
  sha256 "5cbda2eeab0171bbe33f193a051bfbca2138f05a0293fc9229b31b420e543141"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "70e341c0baea6c30db5da7e94e6346b1cdfbbffb3e559112427682bbe1480886"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "70e341c0baea6c30db5da7e94e6346b1cdfbbffb3e559112427682bbe1480886"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "70e341c0baea6c30db5da7e94e6346b1cdfbbffb3e559112427682bbe1480886"
    sha256 cellar: :any_skip_relocation, ventura:        "e10fa0fdcb88dd911a8016460c773a6cefbb09ecc2d79de922b53568593f01b7"
    sha256 cellar: :any_skip_relocation, monterey:       "e10fa0fdcb88dd911a8016460c773a6cefbb09ecc2d79de922b53568593f01b7"
    sha256 cellar: :any_skip_relocation, big_sur:        "e10fa0fdcb88dd911a8016460c773a6cefbb09ecc2d79de922b53568593f01b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "70e341c0baea6c30db5da7e94e6346b1cdfbbffb3e559112427682bbe1480886"
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
