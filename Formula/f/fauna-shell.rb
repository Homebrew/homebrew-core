require "language/node"

class FaunaShell < Formula
  desc "Interactive shell for FaunaDB"
  homepage "https://fauna.com/"
  url "https://registry.npmjs.org/fauna-shell/-/fauna-shell-1.2.1.tgz"
  sha256 "151d0222447add9d7b01125b3d80a8559e1be180e253835abfc8cb1d5b77fa88"
  license "MPL-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "a11ab79a373ed99e271f1fcb2a4e07ea1ddeb79282fdbd6dccdc197f8abe82fc"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "a11ab79a373ed99e271f1fcb2a4e07ea1ddeb79282fdbd6dccdc197f8abe82fc"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "a11ab79a373ed99e271f1fcb2a4e07ea1ddeb79282fdbd6dccdc197f8abe82fc"
    sha256 cellar: :any_skip_relocation, sonoma:         "98446314f3996b624b1fec8306494c83fd608e4afa1d2ece2e37ffed83475dd8"
    sha256 cellar: :any_skip_relocation, ventura:        "98446314f3996b624b1fec8306494c83fd608e4afa1d2ece2e37ffed83475dd8"
    sha256 cellar: :any_skip_relocation, monterey:       "98446314f3996b624b1fec8306494c83fd608e4afa1d2ece2e37ffed83475dd8"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a11ab79a373ed99e271f1fcb2a4e07ea1ddeb79282fdbd6dccdc197f8abe82fc"
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
