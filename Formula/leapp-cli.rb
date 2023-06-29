require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.39.tgz"
  sha256 "061a6db658a8fd3eb1a3b271db09543c3646718d0f5d2fee040e8eb363897ff5"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "bc51b2877072a8e81981bd4c70f67cb4507b28c6e597bad437f6fbd217920707"
    sha256                               arm64_monterey: "8c68bfac1355ef51a79043e32fe4912b9fb5abf45279a28d25ebfdf942026282"
    sha256                               arm64_big_sur:  "abb20d92bc66d6f956c69c1631fc7a97c64ef80975e792279cfe305944f43a7c"
    sha256                               ventura:        "1fded19b60eb231377f7a32532d900082a298908bc5c1af9bf27cbddce80dc74"
    sha256                               monterey:       "69b973949c4817872ee683a4da475ec2a466344a484b1862466b5c8206df0deb"
    sha256                               big_sur:        "d09c782e94aba8eb108716549b3d6d292c904bfa6edee405a4765125903b4ecd"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "1c18e58e2ac048baf041cc372929bef7e8b070ceecc9baec5cf12191ad1e13d7"
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
