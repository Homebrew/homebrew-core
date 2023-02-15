require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.30.tgz"
  sha256 "8089e23076b997de3199243c2fa4bc55f9c1bf16edefb62f959b02955d5b2857"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "2d9fb3d1b87a449f3487062d014abe9c92f726e74ac412c91526db1d44e12f40"
    sha256                               arm64_monterey: "9f5bfc69e1414e0ff6efa6a6ea64d6c8dbc38bec03b5a05fa840c87a139ec173"
    sha256                               arm64_big_sur:  "8d6250e55c113ef0cf4c3a5e3c1be503459fb7913f30fb818f12d0ba5a955a42"
    sha256                               ventura:        "54979fbd481e23f81f353f6ad0e5b59d24eda987c35df27b8d7959f93d35aecb"
    sha256                               monterey:       "46ef8ea66b869a4d09a1a2e09eb2fdd060b21e91ffdbe2653109dfee86ab5e71"
    sha256                               big_sur:        "f8ffe80d6e0babe1dfbe055104acc96e991e4b644f17f1a1b2cc49e0e6606a2d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cf8604276e0e42c5d5f02b3c5717deba42190eae1d69fa9d01d5f07cc6e98443"
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
