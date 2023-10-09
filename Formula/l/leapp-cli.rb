require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.45.tgz"
  sha256 "8f9430f08a7a4969d4ec7caf0b3b6b4140788684b6d141651a3f04913f45def1"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "75d4078358b1623c6c98a6496c535a787257af9d11804ebb761b144922eb53aa"
    sha256                               arm64_ventura:  "87826959654da2c773fce61b1185250c51b61315fd2806b2dfaf7e980921598e"
    sha256                               arm64_monterey: "fc3b05df546ee277c8868f1dadc9714022e6f3dfa48f62a5fd95cb598b1ed810"
    sha256                               sonoma:         "707f5ebf4d974fc48617d981d3e8eb83e51d0448070da3201e57e92698c461f6"
    sha256                               ventura:        "5546a33c1277db5e40954f46dd13c2d55b8887b4ba584915328beec853aa409b"
    sha256                               monterey:       "8e1e3bf3e2a1424b6b805372aedcbbb9cafb391c2d2b4b3c9054e4cdcd1cf1a0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "511328760ae5add56f398325833dd64a190db2961e1ed6d2f2aba5c9aade38d3"
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
