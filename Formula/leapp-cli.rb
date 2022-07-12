require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.14.tgz"
  sha256 "df15db24f3d2c29d6df81cd44f7358061e8699fda0c190e781b5e5b7fec51a3b"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "551419ca4c96713baf2705fab5e7d86991b74af86d3daa82393b9204bee74289"
    sha256                               arm64_big_sur:  "9eadb95caad479ae848818f794b36e4a58cf2dab42c4add574c41befeff9a1be"
    sha256                               monterey:       "1273b1157d3cbfcadbf5fb22aaf7cbcbb37c5364af1e181d538f5ee77a330b7a"
    sha256                               big_sur:        "9461e3f6a60c8646a4c685082b08e878786205907e5d831f56d0ff82e15e49ed"
    sha256                               catalina:       "d5f3e7d44b68355dc9a4e2b067b0b7e615de1144f6949612dd88ab1d49ef27b2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9304cce19db719aa1a2032876310ab3d3354a6795e67a61c29db7349d7425b2b"
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
