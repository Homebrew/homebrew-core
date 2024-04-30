require "language/node"

class Bun < Formula
  desc "All-in-one toolkit for JavaScript and TypeScript apps"
  homepage "https://bun.sh"
  url "https://registry.npmjs.org/bun/-/bun-1.1.6.tgz"
  sha256 "3fb66af767ca156f5b5b03ae38d0218f0069ba5ef7db5c38af79e4044fe18551"
  license "MIT"
  head "https://github.com/oven-sh/bun.git", branch: "main"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/bun --version")

    system bin/"bun", "install", "cowsay"
    assert_match "Hello, world!", shell_output(bin/"bunx cowsay 'Hello, world!'")
  end
end
