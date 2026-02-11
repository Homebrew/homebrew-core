class PlatypusCli < Formula
  desc "Multi-agent coding assistant CLI for software development"
  homepage "https://github.com/firfircelik/platypus-cli"
  url "https://registry.npmjs.org/platypus-cli/-/platypus-cli-1.0.0.tgz"
  sha256 "e99a9fa9063d124f11733f0271babf1fe53f86e6b0d8c77e7c73a8bf0cf5c06a"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *std_npm_args
    bin.install_symlink libexec.glob("bin/*")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/platypus --version")
  end
end
