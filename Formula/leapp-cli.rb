require "language/node"

class LeappCli < Formula
  desc "Cloud credentials manager cli"
  homepage "https://github.com/noovolari/leapp"
  url "https://registry.npmjs.org/@noovolari/leapp-cli/-/leapp-cli-0.1.19.tgz"
  sha256 "4ab762206ee9c473ce89bbca181e1c35a13c987916f38b5a59d5ff8976b36d85"
  license "MPL-2.0"

  bottle do
    sha256                               arm64_monterey: "93685581610c00a3b4d5f5b8baf05af117c18607d58e46132f749353a71080b6"
    sha256                               arm64_big_sur:  "f4475628d66d4ef66cc00509a65d3b30c0105e786bfcf900359c9ac7fcb4359c"
    sha256                               monterey:       "4b51822851e08ceb6c58cf204d4e58255b56d3fdb50095e6cadaf0c4b1e6aab8"
    sha256                               big_sur:        "87b0aad180ab1ef53cf55639dc6dae0748da4151bde5da56b28905a9c07e2f8f"
    sha256                               catalina:       "fb8e202d2f6d5696a303ba60db25d85cea6a3a2f8d9e10feb1ac380314bde3f9"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "244fe2762d2a011dc7ecf53958a786ee7ded3d12bee75fbb7ab31c2a651ce8df"
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
