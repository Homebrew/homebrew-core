require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.21.tgz"
  sha256 "2d0a1ed5e48fcb486c43f5a42bda4df886d2c8e80bc29ec76798075ed848194f"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "c81b2ff623bcc74edc94b3c507d2f2bc6851ffecc82b2b37a922e24a8146267b"
    sha256                               arm64_big_sur:  "5d0751f3d6ddf6901b4cafc684785fe8bc30c3105e67d7cce4abb2ba91f9b444"
    sha256                               monterey:       "1bc3464d3060983637b117c90818387cd95ea004ccaba0428bb7d1fb7c39a82b"
    sha256                               big_sur:        "c826646b1b2b90bda39184eb640167b449ceb000809f1c59525daa17891bab8a"
    sha256                               catalina:       "08009b1d456e170cc0f304546b14adf30f2e31f5c21f2e03d046f2c1fc8250a5"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1095f46ad1565f767f6fbf9879a3733d737c027da15c200d5efcf4726aeb095f"
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
