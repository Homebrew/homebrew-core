require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.3.0.tgz"
  sha256 "1a5ab8f7225a731b3200bf7cc222009e802f089d87a6fa19f5a6978cef92157e"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "2878fdc8ce9cdd5bd2ce47ebf1d8269b4b403405b28a968be901d9329472d87f"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "2878fdc8ce9cdd5bd2ce47ebf1d8269b4b403405b28a968be901d9329472d87f"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "2878fdc8ce9cdd5bd2ce47ebf1d8269b4b403405b28a968be901d9329472d87f"
    sha256 cellar: :any_skip_relocation, sonoma:         "2ad2f1c830200f852cd616da182e958f5eef199ec1267ea15a32182b9b6df84c"
    sha256 cellar: :any_skip_relocation, ventura:        "2ad2f1c830200f852cd616da182e958f5eef199ec1267ea15a32182b9b6df84c"
    sha256 cellar: :any_skip_relocation, monterey:       "2ad2f1c830200f852cd616da182e958f5eef199ec1267ea15a32182b9b6df84c"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2878fdc8ce9cdd5bd2ce47ebf1d8269b4b403405b28a968be901d9329472d87f"
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/fauna endpoint list 2>&1")
    assert_match "Available endpoints:\n", output

    # FIXME: This test seems to stall indefinitely on Linux.
    # https://github.com/jdxcode/password-prompt/issues/12
    return if OS.linux? && ENV["HOMEBREW_GITHUB_ACTIONS"].present?

    output = shell_output("#{bin}/fauna endpoint add https://db.fauna.com:443 " \
                          "--non-interactive --url http://localhost:8443 " \
                          "--secret your_fauna_secret --set-default")
    assert_match "Saved endpoint https://db.fauna.com:443", output

    expected = <<~EOS
      Available endpoints:
      * https://db.fauna.com:443
    EOS
    assert_equal expected, shell_output("#{bin}/fauna endpoint list")
  end
end
