require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.36.tgz"
  sha256 "1b9c726780023b76c40f17ed183f18f9878aa465f9c390b61caf3856426082ee"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_ventura:  "92565121ceae465bfb52e16736790557e8adcf1570df1bff8b5b9b6d70f51897"
    sha256                               arm64_monterey: "047a773ab13e99c454db799786bfe5dcb49ec4bb118f6abcf49c76ab3af4bd0c"
    sha256                               arm64_big_sur:  "ebdd68ff2f1bb630c4d9ef3b820ed85d9a1ab2ea9795e9766f93964a43162c9c"
    sha256                               ventura:        "97375d78b09510cc4504deab7705e6333c95aa30d4d2a239aff10e98888d0df4"
    sha256                               monterey:       "8ea0797188ee677a727750d0484fb8aafe9065a9a85ef6d679792830b74002cd"
    sha256                               big_sur:        "e44b15623ad8b6185cc3c3e8e9ce681be0f3e0e1f73ab754d71737be08cd6306"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "e0f00be3adfd2f44393278fce96d509f44f2cd9648394cb857754c0548f4ba34"
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
