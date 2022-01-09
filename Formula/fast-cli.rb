require "language/node"

class FastCli < Formula
  desc "Test your download and upload speed using fast.com"
  homepage "https://github.com/sindresorhus/fast-cli"
  url "https://github.com/sindresorhus/fast-cli.git",
    tag:      "v3.1.0",
    revision: "d60e276de74cf63ea9f79fcd12dabff385d96bca"
  license "MIT"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system bin/"fast", "--single-line"
  end
end
