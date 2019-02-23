require "language/node"

class AskCli < Formula
  desc "CLI tool for Alexa Skill Kit"
  homepage "https://www.npmjs.com/package/ask-cli"
  url "https://registry.npmjs.org/ask-cli/-/ask-cli-1.6.2.tgz"
  sha256 "ec11c540eec91f2585d1a49b38815a18fcb25434b19d177907fac6a3eb92aef9"

  bottle do
    sha256 "2629073e4994278a96c0a6b519f2cb8182579abf3fb12a98d4d21d33f9b2602f" => :mojave
    sha256 "50ad3a01c2bc7f62ac7269e9c788675f7411bd055d247060aa14385edaa417af" => :high_sierra
    sha256 "5182f936f7bd4a22db51130b7611a3dc43514b9452461279254c5deda721c376" => :sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    output = shell_output("#{bin}/ask deploy 2>&1", 1)
    assert_match %r{\AInvalid json: [^ ]+\/.ask\/cli_config\Z}, output
  end
end
