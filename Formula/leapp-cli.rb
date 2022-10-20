require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.23.tgz"
  sha256 "ce054ac44c4fabefef0713db5fcd25888e556ce8031bad4c188134b0fc46607d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "4bd8f48192d1a21ab985cf22017020f36d6c7e958610b5983c4bf3f58867e0cc"
    sha256                               arm64_big_sur:  "a9d43d624a38f5de9b90931b45aee2e508b4bdd3b556092f3200faa067472c54"
    sha256                               monterey:       "251a61666c1a01939499c6fb5dd229783493ccb112286ba51e9b540bdf257adc"
    sha256                               big_sur:        "0a0ce6c0d9d36e17ef0f1319ab4c6c25fe6b683a0064acf027a0351b1a9b12d0"
    sha256                               catalina:       "98790eaf9e470732c05352cedd924c0b3bf2efa4eb6fd1c731cbda8f7a5add8f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7130f3c90505eef740b633daf8a860820db788e7a6bbb31d46df89bc498a2258"
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
