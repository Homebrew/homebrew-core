require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.22.tgz"
  sha256 "31e9c6be302f0a718dbb37c4017a5c3a22b29c799639cfd130549866e025dd2d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "d2f4df49cd0a7b95143b3935d1eddfd9ffa279cf1c78e1cea7e960c1197ab6fd"
    sha256                               arm64_big_sur:  "0aa63b74d461722a03b4135af79fa153ab432301ce966ad9e9f56c63d895cd3a"
    sha256                               monterey:       "7e728424db5fa33e7a35e7a4752dd7eca2167f71a30461269d2dcb845eee08c5"
    sha256                               big_sur:        "360f4c0dde1be95f25d30244634b97162e168a64906501c2a53da07f53aba941"
    sha256                               catalina:       "1a2128917901061ee1878726525ceb6dda477b7c717c2f43b602d73923bd5847"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "5f8aaf4367db1f5a51ba89f14911d9520aa094fe4860a9c4f3b035f1aae934d9"
  end

  depends_on "pkg-config" => :build
  depends_on "python@3.10" => :build
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
