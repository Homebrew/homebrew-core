require "language/node"

class KeysCli < Formula
  desc "Command-line client for the keys environment manager"
  homepage "https://keys.cm"
  url "https://registry.npmjs.org/keys-cli/-/keys-cli-2.2.4.tgz"
  sha256 "2679ce9d45636be1b6c321effac4060f02d8ebd92c63cbe6391e3016e00d90fc"

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    system "#{bin}/keys", "--reset"
  end
end
