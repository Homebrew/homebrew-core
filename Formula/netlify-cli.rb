require "language/node"

class NetlifyCli < Formula
  desc "Netlify command-line tool"
  homepage "https://www.netlify.com/docs/cli"
  url "https://registry.npmjs.org/netlify-cli/-/netlify-cli-2.15.0.tgz"
  sha256 "fdc4f13b32a07870204c3efa05ca7f6e21cab70560b2d3335f265236c76093ef"
  head "https://github.com/netlify/cli.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "aa27c92501231868c1a9dc1654c13120e818dcdbb32aff9b1660b574b047f68b" => :mojave
    sha256 "d82306a0b892b7fab9d2ec954e8caa48debaa9559151889d4ca653192acbe946" => :high_sierra
    sha256 "ace0634225954524598044727ceecb65651b2b794c56afd010f50c87c3dc52d9" => :sierra
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
