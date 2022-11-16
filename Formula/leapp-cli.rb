require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.26.tgz"
  sha256 "79a91a7b03a1d775363a5e7f087c5b7e1739e5615059010980584558bed9c00f"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "8589ddf349046392b61224a86ffafb2d42cf4ee200eceaabb690f0e218e0ddcb"
    sha256                               arm64_monterey: "1c6f16311d8d8c00e9f88c8d820f552c74b75635e841023f8a75c5a762c95c48"
    sha256                               arm64_big_sur:  "cb94ba081e1de43c04f6d3c33ee187914de411ea2b18910ffc1219b7e609e9a0"
    sha256                               monterey:       "a4e8dc912bc1f20454c77d24d115a677ce8cbd35efb0edeb4239f08adb1c7577"
    sha256                               big_sur:        "ac0d9c98fa704b9107daae532b64526f9c6b53cde9f68e0261d47597c43cb7a9"
    sha256                               catalina:       "c601155bb75bf8d5f965e1f54dc764d64a0163516fd3985086696353cd83c822"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "95274fcb45504c33656ee234f25c602a04d7df9646053b5158d8df3b09a77b2b"
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
