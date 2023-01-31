require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.29.tgz"
  sha256 "0bb30abc47b4f6e7f23629ee9dd79e8bf37f77212f54d2b4598a25f5853a302c"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "02616d27f3582d32be21eae3d24f6ac0523ec134e90c0299551562c5c8a1b6c0"
    sha256                               arm64_monterey: "7c7ad489e637701e51a72eb097c7d019b84fb3cf08d4b9b70c8add225e67dc7e"
    sha256                               arm64_big_sur:  "87e9fb635c9e1a65d3bd44d964d84b7906cde58cdd509dbc15a04c785174ab2a"
    sha256                               ventura:        "3892702996a1ae79b125738056561deb9076277b8510367f837393e8bc2e2d6a"
    sha256                               monterey:       "42c3453710176dabdb9d2f1518df3509f0c9ce50e99e6be2c2158dac007344bf"
    sha256                               big_sur:        "f20f48d8c40608241a2fcfdf91afc31aaf4bb3c9aec43d12619ea1a1a5230024"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "7fdbbc496f0a442a35eed463327776cc23cb8464fad5fafc73abb26b37146776"
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
