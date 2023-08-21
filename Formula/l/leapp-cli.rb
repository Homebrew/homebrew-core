require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.42.tgz"
  sha256 "5c70a574d25f131c37f208aa43715de3f56f21a87eb8f12b403d79267a95a06a"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "7001db7f305c1bdf7611a3265a42f274bdb1802a61d096a86522de328ed561e1"
    sha256                               arm64_monterey: "422381fc31ca91f88ee3ad8c8ca12b4f1844976a41c7f70043ceaf6ad8a31847"
    sha256                               arm64_big_sur:  "bdac090c6294a73ba7ef54155ed6e529009ce1695a66af076a9c3c9d87b4c808"
    sha256                               ventura:        "fb6e9b7e4019090cb7640562ed553cbd637e2bd72adf05d8ffa5d256a51c79d8"
    sha256                               monterey:       "d76553eb3e5079b4119905d33df56a08a9034871df2e9c6dc3220b0b974bb448"
    sha256                               big_sur:        "37a628565578fd5b10ab8fd130deb9190553c577839e8e092d74cd5fc9159b93"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e3436e1d838a0cf65f2ac1e6e3ef9db4d5b81b8a9ea35c5da353939c28b46d0e"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.11" => :build
  depends_on "node"

  on_linux do
    depends_on "libsecret"
  end

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  def caveats
    <<~EOS
      This formula only installs the command-line utilities by default.

      Install Leapp.app with Homebrew Cask:
        brew install --cask leapp
    EOS
  end

  test do
    assert_match "Leapp app must be running to use this CLI",
      shell_output("#{bin}/leapp idp-url create --idpUrl https://example.com 2>&1", 2).strip
  end
end
