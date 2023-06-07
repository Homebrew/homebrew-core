require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.35.tgz"
  sha256 "7b233de08f4693c713ab1b3a2d840895ad750df17778b212bd91c74a87236f2d"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "7d289c98e7e930209e480461782d9bfa4c65136cde3542f0f30dfc8a20f9c4f8"
    sha256                               arm64_monterey: "24dd8c66a272faf9b19e0964662d35122e3d9e1ff08ce7999b4a8a7e5d88f79d"
    sha256                               arm64_big_sur:  "12d5be17fb08c1a8c7b586b0defd0f97eed6366deb4b9417461c8b7e5bce9c35"
    sha256                               ventura:        "a85849ec516c2547e1d2fb72db1b24812e4c711e140348d6e680a6729a1f9245"
    sha256                               monterey:       "1f77a1f70f9df7345b2ad2d769c2c6a7b4613e16567e85be1b3add37228cede0"
    sha256                               big_sur:        "da8a96aa315cc87e73cd0966d93f70c12a41ea37961026bd5985e853b9e32ee2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "fffb81e72213bc7467286db1458f0a64f9b449826ac957390154a9dea747e341"
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
