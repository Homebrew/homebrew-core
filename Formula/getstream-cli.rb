require "language/node"

class GetstreamCli < Formula
  desc "A carefully crafted CLI for managing Stream applications directly from the command line. 🚀"
  homepage "https://github.com/GetStream/stream-cli/blob/master/README.md"
  url "https://registry.npmjs.org/getstream-cli/-/getstream-cli-0.0.1-beta.58.tgz"
  version "0.0.1-beta.58"
  sha256 "3a976e56dd976baf071bcd4c9478b1c2ff67fa55010fb89dddbbbde49df95eea"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    raise "Test not implemented."
  end
end