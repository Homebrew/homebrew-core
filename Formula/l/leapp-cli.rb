require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.56.tgz"
  sha256 "b9edf94de2f0f525ce4c716890016eeabea89a97de2598aab075efff351a850e"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "4a7b697d53e2cc6eef2234660250720a2a3ccc09127ecd9fb954703413e79647"
    sha256                               arm64_ventura:  "8def62ccbf986dadfbcee10eef57b878ac25f5a603adf363d7194f39397be7a7"
    sha256                               arm64_monterey: "2fd095b76fb323ca446af6c41c5aae54f8b83c0e0b8b0f5a3e878c819d7af06c"
    sha256                               sonoma:         "467683072b40338d1488c73793ec8e0a7527995db7d9a80209c79b14a84bc737"
    sha256                               ventura:        "0a1c3aac62819f0efa69cb0f495fbafc84315b86e93afb2a51f82bf89ff101dd"
    sha256                               monterey:       "a12c0f15989eb5a8f0091874ee090faf294d9b30d6b81d17b71327143f919c35"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "506d4d7d7e4416fc50f95a4d3f69815ff3ea4fc0a2851a02dcc18508ab86c171"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

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
