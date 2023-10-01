require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.1.0.tgz"
  sha256 "5a098e3bf6233c66bee1c036089261ee06f17d0a959766ab678b432eeb542797"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "d913959e9aded91766a083f218c9adaf5ae809978bb23b20406ec5569719f5e1"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "56aec30a55d13361f8a067f53e3fbefff85e1362f13f66f9a8c9d98c99f0dcde"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "56aec30a55d13361f8a067f53e3fbefff85e1362f13f66f9a8c9d98c99f0dcde"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "56aec30a55d13361f8a067f53e3fbefff85e1362f13f66f9a8c9d98c99f0dcde"
    sha256 cellar: :any_skip_relocation, sonoma:         "8360a1767cb8b0391589dd5069efae097967b0922964b84d5fd3fcc3641f2441"
    sha256 cellar: :any_skip_relocation, ventura:        "911ae3a75d0dc26cfe4a6686ae7cb99a5c44005a4f906ee301109fcdb01f4eed"
    sha256 cellar: :any_skip_relocation, monterey:       "911ae3a75d0dc26cfe4a6686ae7cb99a5c44005a4f906ee301109fcdb01f4eed"
    sha256 cellar: :any_skip_relocation, big_sur:        "911ae3a75d0dc26cfe4a6686ae7cb99a5c44005a4f906ee301109fcdb01f4eed"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "56aec30a55d13361f8a067f53e3fbefff85e1362f13f66f9a8c9d98c99f0dcde"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna list-endpoints 2>&1", 1)
    assert_match "No endpoints defined", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    pipe_output("#{bin}/fauna add-endpoint https://db.fauna.com:443", "your_fauna_secret\nfauna_endpoint\n")

    output = shell_output("#{bin}/fauna list-endpoints")
    assert_match "fauna_endpoint *\n", output
  end
end
