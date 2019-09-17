require "language/node"

class KmdrCli < Formula
  desc "CLI for explaining shell commands"
  homepage "https://kmdr.sh/"
  url "https://registry.npmjs.org/kmdr/-/kmdr-0.1.34.tgz"
  sha256 "233814fb6665470720468ef419ff17c7fddcc47182785f979149352adfae30cf"
  head "https://github.com/ediardo/kmdr-cli.git"
  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "true"
  end
end
