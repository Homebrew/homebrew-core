require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.36.0.tgz"
  sha256 "414012b95ac2826129f3fb6904039261fa8d1286ed26a665e4b0a98654ea3acc"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "3b2bce3c3322f23fe3eb2ec05001754318ce77c6c04a5fb54876e817ea21e0ca" => :catalina
    sha256 "72cab5bc7fc0984efcfceb309882d4af8c73ef555e50ba0de8ff75c410086751" => :mojave
    sha256 "cf1d2b1cf83e0432a25215f081a6eb4d63980b77d9ce7c99a3fe3ba2871e4bdb" => :high_sierra
  end

  depends_on "node"

  def install
    system "npm", "install", *Language::Node.std_npm_install_args(libexec)
    bin.install_symlink Dir["#{libexec}/bin/*"]
  end

  test do
    (testpath/"test.exp").write <<~EOS
      spawn #{bin}/netlify login
      expect "Opening"
    EOS
    assert_match "Logging in", shell_output("expect -f test.exp")
  end
end
