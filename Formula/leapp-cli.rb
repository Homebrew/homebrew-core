require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.23.tgz"
  sha256 "ce054ac44c4fabefef0713db5fcd25888e556ce8031bad4c188134b0fc46607d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "d6ea0ca8b3267c438c19fe6748bc72ffe8d3d14c2d6ddaf76cdc9ee626e68e48"
    sha256                               arm64_big_sur:  "ffeb563fac646e67b55e453912b89ce7c69294fc0f01959e0cba919ddd3ca378"
    sha256                               monterey:       "98291caaa13ac05ccf69dde839890a87bee09b4c865f0c04eebdfdcb13072bc8"
    sha256                               big_sur:        "0edf87151dfa5a970dac12ecf5427c5a249694acb7807839cdc63b723552b427"
    sha256                               catalina:       "a85dbbbc86c49f276b99d3bf1b05c6e89475a0cd2a59fc3cdaf9c15e94cc4118"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "b421d14098f6ee2ded296cb6274b25ee23ae288e8b15df2de9d9c62788670937"
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
