require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.64.tgz"
  sha256 "fdfa30e87241de6ae9ca76fece4a240a6f23a280492539e4e3fc15a847d74503"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_sonoma:   "dd36cac55f5c2f50efa745d5d621ec15bb47f42056262740f8f46ce2bbd90a98"
    sha256                               arm64_ventura:  "bf4508e2929bc44918d7894374fd42c2471cefd6714886226bc9a990cec65f65"
    sha256                               arm64_monterey: "a4ad568d2f9e81ae3c22bc2a22011b8afc25a22220fd2383e0e652bbbe0d1f15"
    sha256                               sonoma:         "d0904ecb705bca85f01f088784468e0745fb1aa3e1b9b88f5f99ca564b2d0a72"
    sha256                               ventura:        "e66b33f6c4eda11f9b9330a2947738bb3a02c94156ebbdc2fc991cceecdd8751"
    sha256                               monterey:       "a5afc069228107d9903c6934724be4f2f4020d3ccc9f7f0d42bda6345a2e3959"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e7b9b49e7b569de34d6aa83a490d8f19632711d60fb67bb1d31dddd6604a537e"
  end

  depends_on "pkg-config" => :build
  depends_on "node"

  uses_from_macos "python" => :build

  on_linux do
    depends_on "python-setuptools" => :build
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
