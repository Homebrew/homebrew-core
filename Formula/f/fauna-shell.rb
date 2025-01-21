class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-3.0.1.tgz"
  sha256 "258ed7dcb3c369aee861a6e69bf807fea3f00540a6b86d2cfae8d8162e32c2de"
  license "MPL-2.0"
  head "https://github.com/fauna/fauna-shell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
    sha256 cellar: :any_skip_relocation, sonoma:        "0738790ea782077df1050168e258e91a85cdb5c1c61aa540bad7f579f43026e6"
    sha256 cellar: :any_skip_relocation, ventura:       "0738790ea782077df1050168e258e91a85cdb5c1c61aa540bad7f579f43026e6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f61c240a86f5c598cb335a81b0f9c4f1808c04e89a0a6159f837e61e60610a5d"
  end

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    output = shell_output("#{bin}/fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}/fauna endpoint add https://db.fauna.com:443 " \
                          "--no-input --url http://localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https://db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https://db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}/fauna endpoint list")
  end
end
