require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.33.0.tgz"
  sha256 "059f472be466aca6b37d1fd66df113572a8ad4a012dd79d5bd1f786001981256"
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
