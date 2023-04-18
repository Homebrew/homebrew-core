require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.32.tgz"
  sha256 "a4ffe8aa2a3368f468a9996ad0f59b454d25eacdf5dc7935f45ada64fffd5082"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "3ee110b8b4006162844e3300974e3047446d33c604cf43d9b9b006d3f4f8dbc2"
    sha256                               arm64_monterey: "a10b73013355c710d4fc76a9acff7bb3720d93ea9cc5c522b01a4a547a79aab6"
    sha256                               arm64_big_sur:  "21f3d45e547f860ab7fc967dd9d685371243e099f66cf4145a64927ef960a2df"
    sha256                               ventura:        "072f49b6638b82466155b3d020c8e2e82b603bd52036700fd14a5010c766b487"
    sha256                               monterey:       "3ec8be7a332448ff1a6522ac7697dc5f80aaed9d61226ce88cd512bd3f400d31"
    sha256                               big_sur:        "15b40778f1a9f7468aba57d564aa492384aeac87e7f8794297f8bcb7de1673b7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "edb4d17b42f43832c6b13d20d17bd902d0ec3ba9e579d8042496c9821c31fcc7"
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
