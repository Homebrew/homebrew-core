require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.17.tgz"
  sha256 "7ba69db4b1d16194fa3f7bdaff61f9fc0facad6644eef96b5dc18382714879d0"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "a28aa67729bc53e838a85ce1a23591ffd3aea60e882dc93446b20be4a5bf6837"
    sha256                               arm64_big_sur:  "bcce07d1543e6d6d143c869babeb7184e2cb6a9ed963aef253528d1da82f20a4"
    sha256                               monterey:       "fc9aae68b88a9c45531c659d085cb7e0b8996dbba5767bf60e74419bd09ec5fa"
    sha256                               big_sur:        "354055668201579246f558b54923aa2a05409be126e11a99bc7e3413e7b72bb8"
    sha256                               catalina:       "f4ecd20d0b82f0254474ce36916a06c44c3ac246e90a2bca469f948749ad40d3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "2a5a024aea5644ad2a5b41e93e7ba0479e405f973b0ddd37b6e3c62a0ca0a890"
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
