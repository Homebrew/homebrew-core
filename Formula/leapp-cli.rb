require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.25.tgz"
  sha256 "88c469d6c0952b8d4816f7278e524746b30240cb8d43db67574ea00512cc7b19"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "f4816bf5d9a71c281a4e89e404a3e608c2da37dccdfa76e4428050db2d201520"
    sha256                               arm64_big_sur:  "f0e604b723d83117b1c333254c1881c70611a258c39d012bcd78994fc908034d"
    sha256                               monterey:       "74cf19bb9df002d44f589dd6573e6659a36a598e7f200273395e385d48b7f5a5"
    sha256                               big_sur:        "3c0a4822c28099258f84c820e6981d1a604e9272f148db65d45e9246f87b0fa8"
    sha256                               catalina:       "d567f95892ec3e59c190489a0681a00ec826638f85acad38ac3d8f75f73e1f5f"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "9ddadc85847eef48eff74668e0cf0787f08895d03b546c2511ea95359a482fd4"
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
